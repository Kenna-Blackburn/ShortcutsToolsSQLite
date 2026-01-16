//
//  ValueType.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master {
    public struct ValueType: Codable, Hashable {
        public typealias PersistentID = String
        
        public let persistentID: PersistentID
        
        public let kindSpecificMetadata: KindSpecificMetadata?
        
        public let sourceContainerID: Master.Container.PersistentID
        public let coercionUTIs: [String]
        
        public let localization: Locatization?
        
        public let _blobID: Data
        public let _kind: Int
        public let _runtimeFlags: Int?
        public let _runtimeRequirements: Data?
        
        public typealias _Instance = Data
    }
}

extension Master.ValueType {
    init(
        typeRow: RawSQLite.Tables.Types.Row,
        sqlite: RawSQLite,
    ) throws {
        self.persistentID = typeRow.persistentTypeID
        
        self.kindSpecificMetadata = try .init(
            typeRow: typeRow,
            sqlite: sqlite
        )
        
        self.sourceContainerID = try sqlite[RawSQLite.Tables.ContainerMetadata.self]
            .rows
            .first(where: { $0.transientContainerID == typeRow.transientSourceContainerID })
            .unwrap(throwing: LocativeError())
            .persistentContainerID
        
        self.coercionUTIs = sqlite[RawSQLite.Tables.UTTypeCoercions.self]
            .rows
            .filter({ $0.persistentTypeID == typeRow.persistentTypeID })
            .map(\.coercionUTI)
        
        self.localization = try .init(
            typeRow: typeRow,
            sqlite: sqlite,
        )
        
        self._blobID = try typeRow
            .persistentTypeIDBlob
            .data(using: .utf8)
            .unwrap(throwing: LocativeError())
        
        self._kind = typeRow.kind
        
        self._runtimeFlags = typeRow.runtimeFlags
        
        if let runtimeRequirementsBlob = typeRow.runtimeRequirementsBlob {
            self._runtimeRequirements = try runtimeRequirementsBlob
                .data(using: .utf8)
                .unwrap(throwing: LocativeError())
        } else {
            self._runtimeRequirements = nil
        }
    }
}
