//
//  AppDatabase.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/10.
//  Copyright © 2020 cnnl. All rights reserved.
//

import GRDB

/// AppDatabase lets the application access the database.
///
/// It applies the pratices recommended at
/// https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md
final class AppDatabase {
    private let dbQueue: DatabaseQueue
    
    /// Creates an AppDatabase and make sure the database schema is ready.
    init(_ dbQueue: DatabaseQueue) throws {
        self.dbQueue = dbQueue
        try migrator.migrate(dbQueue)
    }
    
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("catalogue") { db in
            // Create a table
            // See https://github.com/groue/GRDB.swift#create-tables
            try db.create(table: "catalogue") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("level", .integer).notNull().defaults(to: 1)
                t.column("indexInLevel", .integer).notNull().defaults(to: 0)
                t.column("name", .text).notNull()
                    // Sort player names in a localized case insensitive fashion by default
                    // See https://github.com/groue/GRDB.swift/blob/master/README.md#unicode
                    .collate(.localizedCaseInsensitiveCompare)
                t.column("title", .text).notNull()
                t.column("icon", .text)
                t.column("isVirtual", .boolean).notNull().defaults(to: 0)
                t.column("isTitled", .boolean).notNull().defaults(to: 0)
                t.column("isSmart", .boolean).notNull().defaults(to: 0)
                t.column("parentId", .integer).notNull().defaults(to: 0)
            }
        }
        
        // Migrations for future application versions will be inserted here:
        // migrator.registerMigration(...) { db in
        //     ...
        // }
        
        return migrator
    }
    
    func fillIfEmpty() throws {
        
    }
}
