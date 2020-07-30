//
//  CatalogueCellView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/30.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class CatalogueCellView: NSTableCellView {

    func setCatalogueEntity(entity: CatalogueEntity) {
        self.textField!.stringValue = entity.title
    }
    
}
