//
//  Database.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/9.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

import GRDB


class Database: NSObject {
    
    var dbQueue: DatabaseQueue

    init(path: String) throws {
        // Simple database connection
        dbQueue = try DatabaseQueue(path: path)
        
        let summary = [
            // name, title, isVirtual, isTitled
            ["all", "全部", true, false],
            ["uncatalog", "未分类", true, false],
            ["untaged", "未标签", true, false],
            ["random", "惊喜组合", true, false],
            ["tags", "标签管理", true, false],
        ]
        
        try dbQueue.write { db in
            try db.execute(sql: """
                CREATE TABLE catalogue (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  level INTEGER NOT NULL DEFAULT 1,
                  indexInLevel INTEGER NOT NULL DEFAULT 0,
                  name TEXT NOT NULL,
                  title TEXT NOT NULL,
                  icon TEXT NULL,
                  isVirtual BOOLEAN NOT NULL DEFAULT 0,
                  isTitled BOOLEAN NOT NULL DEFAULT 0,
                  isSmart BOOLEAN NOT NULL DEFAULT 0,
                  parentId INTEGER NOT NULL DEFAULT 0)
                """)
            
            try db.execute(sql: """
                INSERT INTO catalogue (name, title, isVirtual, isTitled)
                VALUES (?, ?, ?, ?)
                """, arguments: ["all", "全部", true, false])
            try db.execute(sql: """
                INSERT INTO catalogue (name, title, isVirtual, isTitled)
                VALUES (?, ?, ?, ?)
                """, arguments: ["uncataloguncatalog", "未分类", true, false])
            try db.execute(sql: """
                INSERT INTO catalogue (name, title, isVirtual, isTitled)
                VALUES (?, ?, ?, ?)
                """, arguments: ["untaged", "未标签", true, false])
            try db.execute(sql: """
                INSERT INTO catalogue (name, title, isVirtual, isTitled)
                VALUES (?, ?, ?, ?)
                """, arguments: ["random", "惊喜组合", true, false])
            try db.execute(sql: """
                    INSERT INTO catalogue (name, title, isVirtual, isTitled)
                    VALUES (?, ?, ?, ?)
                    """, arguments: ["tags", "标签管理", true, false])
            try db.execute(sql: """
                            INSERT INTO catalogue (name, title, isVirtual, isTitled)
                            VALUES (?, ?, ?, ?)
                            """, arguments: ["smart", "智能文件夹", true, true])
            try db.execute(sql: """
                                    INSERT INTO catalogue (name, title, isVirtual, isTitled)
                                    VALUES (?, ?, ?, ?)
                                    """, arguments: ["folders", "文件夹", true, true])
            
            let parisId = db.lastInsertedRowID
        }
    }
}
