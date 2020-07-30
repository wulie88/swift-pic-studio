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
    func didSelectItems(items: Array<DesktopFileEntity>)
}

class ImageCollectionView: NSView {

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
        toobar.setup(type: flowLayout!.type)
        toobar.delegate = self
        
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

extension ImageCollectionView : NSCollectionViewDelegate {
    
    
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, shouldDeselectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach { (indexPath) in
            var selected = true
            if selectedIndexPaths.contains(indexPath) {
                selected = false
                selectedIndexPaths.removeAll { (_indexPath) -> Bool in
                    return _indexPath == indexPath
                }
                collectionView.deselectItems(at: Set([indexPath]))
            } else {
                selectedIndexPaths.append(indexPath)
            }
            
            let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
            if (imageEntity != nil) {
                imageEntity?.isSelected = selected
            }
        }
        collectionView.reloadItems(at: indexPaths)
        
        var items: Array<DesktopFileEntity> = []
        selectedIndexPaths.forEach { (indexPath) in
            let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
            if (imageEntity != nil) {
                items.append(imageEntity!)
            }
        }
        delegate?.didSelectItems(items: items)
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach { (indexPath) in
            let imageEntity = flowLayout!.imageEntity(withIndexPath: indexPath)
            if (imageEntity != nil) {
                imageEntity?.isSelected = false
            }
        }
        collectionView.reloadItems(at: indexPaths)
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
