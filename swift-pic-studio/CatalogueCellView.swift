//
//  CatalogueCellView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/30.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class CatalogueCellView: NSTableCellView {
    
    @IBOutlet weak var expandButton: NSButton!
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var countLabel: NSTextField!

    func setCatalogueEntity(entity: CatalogueEntity) {
        expandButton.isHidden = true
        self.textField!.stringValue = entity.title
    }
    
}
