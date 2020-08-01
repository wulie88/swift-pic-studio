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
    
    @IBOutlet weak var outlineView: NSOutlineView!

    func setup(catalogs: [CatalogueEntity]) {
        self.catalogs = catalogs
        
        wantsLayer = true
        layer?.cornerRadius = 6
        layer?.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMaxXMinYCorner]
        layer?.masksToBounds = true
        layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.1).cgColor
//        layer?.shadowOpacity = 10.0
//        layer?.shadowColor = NSColor.white.cgColor
//        layer?.shadowOffset = NSMakeSize(-3, -3)
        outlineView.backgroundColor = NSColor.clear
        
        outlineView.reloadData()
    }
    
//    override func draw(_ dirtyRect: NSRect) {
//        let sourceImage: CIImage? = FolderViewController.sharedBlurredBackgroundImage
//        let sourceFrame: NSRect? = FolderViewController.sharedBackgroundFrame
//        guard sourceImage != nil else {
//            return
//        }
//
//        sourceImage!.draw(in: dirtyRect, from: frame, operation: .copy, fraction: 1)
//    }
}

extension CatalogueListView : NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        let entity = item as? CatalogueEntity
        if entity == nil {
            return catalogs.count
        } else {
            return entity!.children.count
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        let entity = item as? CatalogueEntity
        if entity == nil {
            return catalogs[index]
        } else {
            return entity!.children[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let entity = item as? CatalogueEntity
        return entity?.isExpandable ?? false
    }
}

extension CatalogueListView : NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let entity = item as! CatalogueEntity
        if entity.isTitled {
            guard let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CatalogueTitledCellView"), owner: self) as? CatalogueTitledCellView else {
                return nil
            }
            
            cellView.setCatalogueEntity(entity: entity)
            
            return cellView
        } else {
            guard let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CatalogueCellView"), owner: self) as? CatalogueCellView else {
                return nil
            }
            
            cellView.setCatalogueEntity(entity: entity)
            
            return cellView
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 44
    }
}
