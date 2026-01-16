//
//  Parameter+Localization.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master.Action.Parameter {
    public struct Localization: Codable, Hashable {
        public let localeID: String
        
        public let name: String
        
        public let descriptionSummary: String?
        
        public let booleanDisplay: BooleanDisplay?
    }
}

extension Master.Action.Parameter.Localization {
    init(
        parameterRow: RawSQLite.Tables.Parameters.Row,
        sqlite: RawSQLite,
    ) throws {
        let parameterLocalizationRow = try sqlite[RawSQLite.Tables.ParameterLocalizations.self]
            .rows
            .first {
                $0.transientToolID == parameterRow.transientToolID &&
                $0.persistentParameterID == parameterRow.persistentParameterID
            }
            .unwrap(throwing: LocativeError())
        
        self.localeID = parameterLocalizationRow.locale
        
        self.name = parameterLocalizationRow.name
        
        self.descriptionSummary = parameterLocalizationRow.description
        
        self.booleanDisplay = .init(
            true: parameterLocalizationRow.trueString,
            false: parameterLocalizationRow.falseString,
        )
    }
}
