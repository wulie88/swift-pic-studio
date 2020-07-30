//
//  CatalogueListView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/29.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

/**
 目录列表
 */
class CatalogueListView: NSView {
    
    var catalogs: [CatalogueEntity] = []
    
    @IBOutlet weak var tableView: NSTableView!

    func setup(catalogs: [CatalogueEntity]) {
        self.catalogs = catalogs
        
        tableView.reloadData()
    }
}

extension CatalogueListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.catalogs.count
    }
}

extension CatalogueListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CatalogueCellView"), owner: self) as? CatalogueCellView else {
            return nil
        }
        
        let entity = catalogs[row]
        cellView.setCatalogueEntity(entity: entity)
        
        return cellView
    }
}
