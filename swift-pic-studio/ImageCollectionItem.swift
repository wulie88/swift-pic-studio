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
        
        imageView!.imageAlignment = .alignCenter
        imageView!.imageScaling = .scaleProportionallyDown
        imageView!.layer?.cornerRadius = 7
        imageView!.layer?.masksToBounds = true
        imageView!.layer?.borderColor = NSColor.lightGray.cgColor
        imageView!.layer?.borderWidth = 1
    }
    
    func setImageEntity(imageEntity: DesktopFileEntity) {
        self.imageEntity = imageEntity
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
