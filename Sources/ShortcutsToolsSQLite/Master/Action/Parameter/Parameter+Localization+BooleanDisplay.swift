//
//  Parameter+Localization+BooleanDisplay.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation

extension Master.Action.Parameter.Localization {
    public struct BooleanDisplay: Codable, Hashable {
        public var trueString: String?
        public var falseString: String?
        
        private enum CodingKeys: String, CodingKey {
            case trueString = "true"
            case falseString = "false"
        }
    }
}

extension Master.Action.Parameter.Localization.BooleanDisplay {
    init?(
        true trueString: String?,
        false falseString: String?,
    ) {
        self.trueString = trueString
        self.falseString = falseString
        
        if self.trueString == nil,
           self.falseString == nil
        {
            return nil
        }
    }
}
