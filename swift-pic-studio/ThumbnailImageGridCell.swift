//
//  ThumbnailImageGridCell.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ThumbnailImageGridCell: NSTableCellView {
    var imageViews: [NSImageView] = []
    var imageEntities: [DesktopFileEntity] = []
    var line: ThumbnailImageGridLine? = nil
    
    func clear () {
        imageViews.forEach { (imageView) in
            imageView.removeFromSuperview()
        }
        imageEntities.forEach { (imageEntity) in
            imageEntity.removeObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath)
        }
        imageViews.removeAll()
        imageEntities.removeAll()
    }

    func setLine(line: ThumbnailImageGridLine) {
        clear()
        
        self.line = line
        line.imageEntities.forEach { (entity) in
            if !entity.isMember(of: DesktopFileEntity.self) {
                return
            }
            
            let imageEntity = entity as DesktopFileEntity
            let imageView = NSImageView()
            imageView.imageAlignment = .alignCenter
            imageView.imageScaling = .scaleProportionallyDown
            imageView.image = imageEntity.thumbnailImage
            self.addSubview(imageView)
            imageViews.append(imageView)
            imageEntities.append(imageEntity)
            
            imageEntity.addObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath, options: .new, context: nil)
            imageEntity.load()
        }
    }
    
    override func layout() {
        super.layout()
        
        if (line != nil) {
            var x: CGFloat = line!.spacing
            let h: CGFloat = line!.rowHeight
            for (index, imageView) in imageViews.enumerated() {
                let size = imageEntities[index].size
                let w = size.width / size.height * h
                imageView.frame = NSMakeRect(x, 0, w, h)
                x += w + line!.spacing
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == DesktopFileEntity.ThumbnailImageLoadedKeyPath) {
            let imageEntity = object as! DesktopFileEntity
            let index = imageEntities.firstIndex(of: imageEntity)
            let imageView = imageViews[index!]
            DispatchQueue.main.async {
                imageView.image = imageEntity.thumbnailImage
            }
        }
    }
    
    deinit {
        imageEntities.forEach { (imageEntity) in
            imageEntity.removeObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath)
        }
    }
}
