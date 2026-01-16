// swift-tools-version: 6.2

//
//  Package.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 1/16/26.
//

import PackageDescription

let package = Package(
    name: "ShortcutsToolsSQLite",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(
            name: "ShortcutsToolsSQLite",
            targets: ["ShortcutsToolsSQLite"],
        ),
    ],
    targets: [
        .target(
            name: "ShortcutsToolsSQLite",
        ),
        .testTarget(
            name: "ShortcutsToolsSQLiteTests",
            dependencies: ["ShortcutsToolsSQLite"],
        ),
    ]
)
