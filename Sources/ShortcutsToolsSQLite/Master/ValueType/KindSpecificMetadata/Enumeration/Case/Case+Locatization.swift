//
//  Case+Locatization.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master.ValueType.KindSpecificMetadata.Enumeration.Case {
    public struct Locatization: Codable, Hashable {
        public let localeID: String
        
        public let title: String?
        public let subtitle: String?
    }
}

extension Master.ValueType.KindSpecificMetadata.Enumeration.Case.Locatization {
    init(
        caseRow: RawSQLite.Tables.EnumerationCases.Row,
        sqlite: RawSQLite,
    ) throws {
        self.localeID = caseRow.locale
        
        self.title = caseRow.title
        
        self.subtitle = caseRow.subtitle
    }
}
