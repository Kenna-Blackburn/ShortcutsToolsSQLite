//
//  Action.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master {
    public struct Action: Codable, Hashable {
        public typealias PersistentID = String
        
        public let persistentID: PersistentID
        
        public let parameters: [Parameter]
        public let outputTypeID: ValueType.PersistentID
        
        public let sourceContainerID: Master.Container.PersistentID
        public let attributionContainerID: Master.Container.PersistentID?
        
        public let localization: Localization
        
        public let _flags: Int
        public let _visibilityFlags: Int
        public let _requirements: Data
        public let _authenticationPolicy: String
        public let _customIcon: Data?
        public let _sourceActionProviderID: String
        public let _outputTypeInstance: ValueType._Instance
    }
}

extension Master.Action {
    init(
        toolRow: RawSQLite.Tables.Tools.Row,
        sqlite: RawSQLite,
    ) throws {
        self.persistentID = toolRow.persistentToolID
        
        self.parameters = try sqlite[RawSQLite.Tables.Parameters.self]
            .rows
            .filter({ $0.transientToolID == toolRow.transientToolID })
            .sorted(using: SortDescriptor(\.sortOrder))
            .map({ try Master.Action.Parameter(parameterRow: $0, sqlite: sqlite) })
        
        self.outputTypeID = try sqlite[RawSQLite.Tables.ToolOutputTypes.self]
            .rows
            .first(where: { $0.transientToolID == toolRow.transientToolID })
            .unwrap(throwing: LocativeError())
            .persistentTypeID
        
        self.sourceContainerID = try sqlite[RawSQLite.Tables.ContainerMetadata.self]
            .rows
            .first(where: { $0.transientContainerID == toolRow.transientSourceContainerID })
            .unwrap(throwing: LocativeError())
            .persistentContainerID
        
        if let transientAttributionContainerID = toolRow.transientAttributionContainerID {
            self.attributionContainerID = try sqlite[RawSQLite.Tables.ContainerMetadata.self]
                .rows
                .first(where: { $0.transientContainerID == transientAttributionContainerID })
                .unwrap(throwing: LocativeError())
                .persistentContainerID
        } else {
            self.attributionContainerID = nil
        }
        
        self.localization = try .init(
            toolRow: toolRow,
            sqlite: sqlite,
        )
        
        self._flags = toolRow.flags
        
        self._visibilityFlags = toolRow.visibilityFlags
        
        self._requirements = try toolRow
            .requirementsBlob
            .data(using: .utf8)
            .unwrap(throwing: LocativeError())
        
        self._authenticationPolicy = toolRow.authenticationPolicy
        
        if let customIconBlob = toolRow.customIconBlob {
            self._customIcon = try customIconBlob
                .data(using: .utf8)
                .unwrap(throwing: LocativeError())
        } else {
            self._customIcon = nil
        }
        
        self._sourceActionProviderID = toolRow.sourceActionProvider
        
        self._outputTypeInstance = try toolRow
            .outputTypeInstanceBlob
            .data(using: .utf8)
            .unwrap(throwing: LocativeError())
    }
}
