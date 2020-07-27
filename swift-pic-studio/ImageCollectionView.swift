//
//  ImageCollectionView.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ImageCollectionView: NSView {

    var flowLayout: ImageFlowLayout?
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    func updateItems(items: [DesktopFileEntity]) {
        flowLayout = ImageFlowLayout()
        flowLayout?.setup(items: items, containerWidth: self.frame.width)
        collectionView.collectionViewLayout = flowLayout

        self.wantsLayer = true

        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        self.needsLayout = true
    }
    
    override func layout() {
        super.layout()
        
        collectionView.reloadData()
    }
}

extension ImageCollectionView : NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = flowLayout?.items?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ThumbnailImageCollectionItem")) as! ImageCollectionItem
        let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
        if (imageEntity != nil) {
            item.setImageEntity(imageEntity: imageEntity!)
        }
        
        return item
    }
}
