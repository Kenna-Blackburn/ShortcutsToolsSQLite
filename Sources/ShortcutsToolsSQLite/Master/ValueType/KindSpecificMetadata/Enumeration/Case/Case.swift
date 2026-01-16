//
//  Case.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master.ValueType.KindSpecificMetadata.Enumeration {
    public struct Case: Codable, Hashable {
        public typealias PersistentID = String
        
        public let persistentID: PersistentID
        
        public let localization: Locatization
    }
}

extension Master.ValueType.KindSpecificMetadata.Enumeration.Case {
    init(
        caseRow: RawSQLite.Tables.EnumerationCases.Row,
        sqlite: RawSQLite,
    ) throws {
        self.persistentID = caseRow.persistentCaseID
        
        self.localization = try .init(
            caseRow: caseRow,
            sqlite: sqlite,
        )
    }
}
