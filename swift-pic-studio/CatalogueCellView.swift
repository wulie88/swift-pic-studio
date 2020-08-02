//
//  CatalogueCellView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/30.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol CatalogueCellViewDelegate : NSObjectProtocol {
    
    func cell(cell:CatalogueTitledCellView, titleFieldDidChange textField: NSTextField)
}

class CatalogueCellView: NSTableCellView {
    
    weak var entity: CatalogueEntity?
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var countLabel: NSTextField!
    var delegate: CatalogueCellViewDelegate?

    func setCatalogueEntity(_ entity: CatalogueEntity) {
        self.entity = entity
        self.textField!.stringValue = entity.title
        if (entity.isEditing) {
            self.textField!.becomeFirstResponder()
        }
    }
    
    @IBAction func textFieldDidChange(textField :NSTextField) {
        entity?.title = textField.stringValue
    }
}
