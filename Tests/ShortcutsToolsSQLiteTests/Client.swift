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
        .downloadsDirectory
        .appending(path: "Tools-prod.v63-D091054F-9E52-45C9-AB80-E4495544BD39.sqlite")

    let outputURL = URL
        .downloadsDirectory
        .appending(path: "Master.json")

    let master = try Master(sqliteURL: sqliteURL)
    try master.data().write(to: outputURL, options: [.atomic, .completeFileProtection])
}
