//
//  MenuCollectionView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/3.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class MenuOutlineView: NSOutlineView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        return nil
    }
}
