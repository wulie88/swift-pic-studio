//
//  AppDelegate.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var documentController: DocumentController?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        documentController = DocumentController()
        Library.instance(recentDocumentURLs: documentController!.recentDocumentURLs)
        print("recentDocumentURLs", documentController!.recentDocumentURLs)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func openDocument(_ openMenuItem: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        let i = openPanel.runModal()
        if i == NSApplication.ModalResponse.OK {
            print("The directory selected is " + openPanel.url!.absoluteString)
            
            documentController?.openDocument(withContentsOf: openPanel.url!, display: true, completionHandler: { (document, res, error) in
                
            })
        }
    }
}

