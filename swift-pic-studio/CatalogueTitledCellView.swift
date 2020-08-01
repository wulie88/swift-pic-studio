//
//  CatalogueTitledCellView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/2.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class CatalogueTitledCellView: NSTableCellView {
    
    @IBOutlet weak var expandButton: NSButton!

    func setCatalogueEntity(entity: CatalogueEntity) {
        self.textField!.stringValue = entity.title
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
