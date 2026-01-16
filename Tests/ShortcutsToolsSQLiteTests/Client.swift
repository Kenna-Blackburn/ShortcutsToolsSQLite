//
//  Client.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 1/16/26.
//

import Foundation
import Testing
@testable import ShortcutsToolsSQLite

@Test("Client")
func client() async throws {
    let sqliteURL = URL
        .desktopDirectory
        .appending(path: "SESCA/Tools-prod_1.sqlite")

    let outputURL = URL
        .desktopDirectory
        .appending(path: "SESCA/Master.json")

    let master = try Master(sqliteURL: sqliteURL)
    try master.data().write(to: outputURL, options: [.atomic, .completeFileProtection])
}
