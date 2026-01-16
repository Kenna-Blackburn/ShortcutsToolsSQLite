//
//  KindSpecificMetadata.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master.ValueType {
    public struct KindSpecificMetadata: Codable, Hashable {
        public var entity: Entity?
        public var enumeration: Enumeration?
    }
}

extension Master.ValueType.KindSpecificMetadata {
    init?(
        typeRow: RawSQLite.Tables.Types.Row,
        sqlite: RawSQLite,
    ) throws {
        if sqlite[RawSQLite.Tables.EntityProperties.self]
            .rows
            .contains(where: { $0.persistentEntityID == typeRow.persistentTypeID })
        {
            self.entity = try .init(
                typeRow: typeRow,
                sqlite: sqlite,
            )
        }
        
        if sqlite[RawSQLite.Tables.EnumerationCases.self]
            .rows
            .contains(where: { $0.persistentEnumerationID == typeRow.persistentTypeID })
        {
            self.enumeration = try .init(
                typeRow: typeRow,
                sqlite: sqlite,
            )
        }
        
        if self.entity == nil,
           self.enumeration == nil
        {
            return nil
        }
    }
}
