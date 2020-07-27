//
//  ThumbnailImageCollectionView.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ThumbnailImageCollectionView: NSView {

    var flowLayout: ThumbnailImageFlowLayout?
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    func updateItems(items: [DesktopFileEntity]) {
        flowLayout = ThumbnailImageFlowLayout()
        flowLayout?.setup(items: items, containerWidth: self.frame.width)
        collectionView.collectionViewLayout = flowLayout

        self.wantsLayer = true

        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        self.needsLayout = true
    }
    
}

extension ThumbnailImageCollectionView : NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return flowLayout?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ThumbnailImageCollectionItem")) as! ThumbnailImageCollectionItem
        
        return item
    }
}
