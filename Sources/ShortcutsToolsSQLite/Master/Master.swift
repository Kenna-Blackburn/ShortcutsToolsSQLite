//
//  Master.swift
//  ShortcutsToolsSQLite
//
//  Created by Kenna Blackburn on 11/27/25.
//

import Foundation
import SQLite3

public struct Master: Codable, Hashable {
    public let actions: [Action]
    
    public let valueTypes: [ValueType]
    
    public let containers: [Container]
}

extension Master {
    public func data() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        return try encoder.encode(self)
    }
    
    public init(data: Data) throws {
        let decoder = JSONDecoder()
        
        self = try decoder.decode(Self.self, from: data)
    }
}

extension Master {
    #if os(macOS)
    public init(sqliteURL: URL) throws {
        let temporaryDirectory = URL
            .temporaryDirectory
            .appending(path: UUID().uuidString)
        
        // sqlite -> json
        @discardableResult
        func runCommand(_ command: String) throws -> String? {
            let process = Process()
            process.executableURL = URL(filePath: "/bin/zsh")
            process.arguments = ["-c", command]
            
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe
            
            try process.run()
            
            process.waitUntilExit()
            
            guard let data = try pipe.fileHandleForReading.readToEnd(),
                  let string = String(data: data, encoding: .utf8)
            else {
                return nil
            }
            
            return string
        }
        
        let jsonDirectory = temporaryDirectory.appending(path: "RawJSON")
        
        try FileManager
            .default
            .createDirectory(at: jsonDirectory, withIntermediateDirectories: true)
        
        let tableNames = RawSQLite.tableTypes.map({ $0.name })
        
        for tableName in tableNames {
            let jsonURL = jsonDirectory
                .appending(path: tableName + ".json")
            
            try runCommand("sqlite3 '\(sqliteURL.path())' -json \"SELECT * FROM \(tableName);\" > '\(jsonURL.path())'")
        }
        
        // json -> memory
        func decode<Table: RawSQLiteTable>(
            type: Table.Type
        ) throws -> Table {
            let url = jsonDirectory.appending(path: Table.name + ".json")
            
            do {
                let data = try Data(contentsOf: url)
                let rows = try JSONDecoder().decode([Table.Row].self, from: data)
                let table = Table(rows: rows)
                
                return table
            } catch {
                print("Failed to parse json at '\(url)'. Substituting with empty table.")
                return Table(rows: [])
            }
        }
        
        let tables = try RawSQLite
            .tableTypes
            .map({ try decode(type: $0) })
        
        // tail
        let sqlite = RawSQLite(tables: tables)
        try self.init(sqlite: sqlite)
    }
    
    private init(sqlite: RawSQLite) throws {
        self.actions = try sqlite[RawSQLite.Tables.Tools.self]
            .rows
            .map({ try Master.Action(toolRow: $0, sqlite: sqlite) })
            .sorted(using: SortDescriptor(\.persistentID))
        
        self.valueTypes = try sqlite[RawSQLite.Tables.Types.self]
            .rows
            .map({ try Master.ValueType(typeRow: $0, sqlite: sqlite) })
            .sorted(using: SortDescriptor(\.persistentID))
        
        self.containers = try sqlite[RawSQLite.Tables.ContainerMetadata.self]
            .rows
            .map({ try Master.Container(containerRow: $0, sqlite: sqlite) })
            .sorted(using: SortDescriptor(\.persistentID))
    }
    #endif
}
