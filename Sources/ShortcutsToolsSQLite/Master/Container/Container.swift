//
//  Container.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master {
    public struct Container: Codable, Hashable {
        public typealias PersistentID = String
        
        public let persistentID: PersistentID
        
        public let bundleVersionString: String
        public let teamID: String
        
        public let localization: Localization
        
        public let _origin: Int
        public let _containerType: Int
    }
}

extension Master.Container {
    init(
        containerRow: RawSQLite.Tables.ContainerMetadata.Row,
        sqlite: RawSQLite,
    ) throws {
        self.persistentID = containerRow.persistentContainerID
        
        self.bundleVersionString = containerRow.bundleVersion
        
        self.teamID = containerRow.teamID
        
        self.localization = try .init(
            containerRow: containerRow,
            sqlite: sqlite,
        )
        
        self._origin = containerRow.origin
        
        self._containerType = containerRow.containerType
    }
}
