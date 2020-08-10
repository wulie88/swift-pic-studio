//
//  Library.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/9.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa
import GRDB

/// 资料库
class Library: NSObject {
    
    private static var items: [Library] = []
    static func instance(recentDocumentURLs urls: [URL]) {
        urls.forEach { (url) in
            let lib = Library(fileUrl: url)
            if (lib.isVaild) {
                items.append(lib)
            }
        }
        current = items.first
    }

    static var current: Library?
    
    var isVaild = false
    var rootPath: String
    var libraryPath: String
    var databasePath: String
    var name: String
    var database: Database?
    
    init(fileUrl: URL) {
        self.rootPath = fileUrl.relativePath
        self.name = fileUrl.lastPathComponent
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let lib = fileUrl.appendingPathComponent("\(namespace).pslibrary", isDirectory: true)
        self.libraryPath = lib.relativePath
        let dbfile = lib.appendingPathComponent("database.sqlite", isDirectory: false)
        self.databasePath = dbfile.relativePath
        
        let fileManager = FileManager()
        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: rootPath, isDirectory: &isDir) {
            return
        }
        
        do {
            if !fileManager.fileExists(atPath: libraryPath, isDirectory: &isDir) {
                try fileManager.createDirectory(atPath: libraryPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error {
            print("createDirectory", lib.absoluteString, error)
            return
        }
        

    }
}
