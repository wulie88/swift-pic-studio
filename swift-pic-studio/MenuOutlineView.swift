//
//  MenuCollectionView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/3.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol MenuOutlineViewDelegate : NSObjectProtocol {
    func outlineView(_ outlineView: MenuOutlineView, menuForItem item: Any?, atRow index: Int) -> NSMenu?
}

class MenuOutlineView: NSOutlineView {
    
    weak open var menuDelegate: MenuOutlineViewDelegate?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let point = self.convert(event.locationInWindow, from: nil)
        let index = self.row(at: point)
        let item = self.item(atRow: index)
        return menuDelegate?.outlineView(self, menuForItem: item, atRow: index)
    }
}
