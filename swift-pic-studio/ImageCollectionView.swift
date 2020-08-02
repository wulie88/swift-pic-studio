//
//  ImageCollectionView.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol ImageCollectionViewDelegate : NSObjectProtocol {
    
    /// 选择了
    func updateSelectItems(items: Array<DesktopFileEntity>)
    
    func presentImageEditer(items: Array<DesktopFileEntity>, currentIndex: Int, sender: NSView)
}

class ImageCollectionView: NSView, ImageCollectionItemDelegate {
    
    var isHoldCommandKey = false

    var flowLayout: ImageCollectionFlowLayout?
    
    weak open var delegate: ImageCollectionViewDelegate?
    
    @IBOutlet weak var toobar: ImageCollectionToolbar!
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var selectedIndexPaths: Array<IndexPath> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateItems(items: [DesktopFileEntity]) {
        flowLayout = ImageCollectionFlowLayout()
        flowLayout!.setup(items: items)
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.setDraggingSourceOperationMask(.link, forLocal: true)
        collectionView.registerForDraggedTypes([.png])
        
        toobar.setup(type: flowLayout!.type)
        toobar.delegate = self
    }
    
    override func layout() {
        super.layout()
        
        collectionView.backgroundView = nil
        collectionView.backgroundColors = [NSColor.clear]
        
        collectionView.reloadData()
    }
    
    func notifySelectItemsDidUpdate() {
        let selectionIndexPaths = collectionView.selectionIndexPaths
        var items: [DesktopFileEntity] = []
        selectionIndexPaths.forEach { (indexPath) in
            let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
            items.append(imageEntity!)
        }
        delegate?.updateSelectItems(items: items)
    }
    
    func itemDidDoubleClick(imageEntity: DesktopFileEntity, indexPath: IndexPath) {
        var items: [DesktopFileEntity] = []
        flowLayout?.cachedAttributes.forEach({ (attrs) in
            items.append(attrs.imageEntity!)
        })
        guard let item = collectionView.item(at: indexPath) as? ImageCollectionItem else {
            return
        }
        delegate?.presentImageEditer(items: items, currentIndex: indexPath.item, sender: item.view)
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
        item.delegate = self
        item.indexPath = indexPath
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        let indexPath: IndexPath = IndexPath(item: index, section: 0)
        let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
        return imageEntity?.thumbnailImage
    }
}

extension ImageCollectionView : NSCollectionViewDelegate {
    
    
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, shouldDeselectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("didSelectItemsAt", indexPaths)
        indexPaths.forEach { (indexPath) in
            guard let item = collectionView.item(at: indexPath) as? ImageCollectionItem else {
                return
            }
            item.isSelected = true
        }
        
        notifySelectItemsDidUpdate()
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        print("didDeselectItemsAt", indexPaths)
        indexPaths.forEach { (indexPath) in
            guard let item = collectionView.item(at: indexPath) as? ImageCollectionItem else {
                return
            }
            item.isSelected = false
        }
        
        notifySelectItemsDidUpdate()
    }
}

extension ImageCollectionView : ImageCollectionToolbarDelegate {
    
    func flowLayout(didSort sort: ImageCollectionFlowLayoutSort, byOrder order: ImageCollectionFlowLayoutOrder) {
        flowLayout!.sort = sort
        flowLayout!.order = order
        collectionView.reloadData()
    }
    
    
    func properColsDidChanged(properCols: Int) {
        flowLayout!.properCols = 6 - properCols
        collectionView.reloadData()
    }
    
    func flowLayoutTypeDidChanged(type: ImageCollectionFlowLayoutType) {
        flowLayout!.type = type
        collectionView.reloadData()
    }
}
