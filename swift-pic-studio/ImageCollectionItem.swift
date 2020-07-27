//
//  ImageCollectionItem.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa
     
class ImageCollectionItem: NSCollectionViewItem {
    
    weak var imageEntity: DesktopFileEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    func setImageEntity(imageEntity: DesktopFileEntity) {
        self.imageEntity = imageEntity
        
        imageView!.imageAlignment = .alignCenter
        imageView!.imageScaling = .scaleProportionallyDown
        imageView!.image = imageEntity.thumbnailImage
        
        imageEntity.addObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath, options: .new, context: nil)
        imageEntity.load()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == DesktopFileEntity.ThumbnailImageLoadedKeyPath) {
            let imageEntity = object as! DesktopFileEntity
            DispatchQueue.main.async {
                self.imageView!.image = imageEntity.thumbnailImage
            }
        }
    }
    
    deinit {
        self.imageEntity?.removeObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath)
    }
}
