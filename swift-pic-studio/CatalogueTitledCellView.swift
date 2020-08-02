//
//  CatalogueTitledCellView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/2.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol CatalogueTitledCellViewDelegate : NSObjectProtocol {
    func cell(cell:CatalogueTitledCellView, addButtonDidClick button: NSButton)
}

class CatalogueTitledCellView: NSTableCellView {
    
    weak var entity: CatalogueEntity?
    
    var delegate: CatalogueTitledCellViewDelegate?

    func setCatalogueEntity(_ entity: CatalogueEntity) {
        self.entity = entity
        self.textField!.stringValue = entity.title
    }
    
    @IBAction func addButtonDidClick(button: NSButton) {
        delegate?.cell(cell: self, addButtonDidClick: button)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
