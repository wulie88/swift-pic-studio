//
//  ImageFlowLayout.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ThumbnailImageLayoutAttributes: NSCollectionViewLayoutAttributes {
    var imageEntity: DesktopFileEntity?
}

class ImageFlowLayout: NSCollectionViewFlowLayout {
    
    var lines: [ThumbnailImageGridLine] = []
    var cachedAttributes: [ThumbnailImageLayoutAttributes] = []
    
    var items: [DesktopFileEntity]?
    var maxWidth: CGFloat = 0
    var maxHeight: CGFloat = 0
    
    func setup(items: [DesktopFileEntity], containerWidth: CGFloat) {
        self.items = items
    }
    
    func imageEntity(withIndexPath indexPath:IndexPath) -> DesktopFileEntity? {
        return cachedAttributes[indexPath.item].imageEntity
    }
    
    override func prepare() {
        let width = collectionView?.frame.width ?? 0
        
        // layout line
        let properHeight:CGFloat = width / 3
        let spacing:CGFloat = 10
        var lastLine:ThumbnailImageGridLine? = nil
        self.lines.removeAll()
        for (_, entity) in self.items!.enumerated() {
            if !entity.isMember(of: DesktopFileEntity.self) {
                continue
            }
            
            let imageEntity = entity as DesktopFileEntity
            let size = imageEntity.size
            if (size == CGSize.zero) {
                continue
            }
            
            if (lastLine == nil) {
                lastLine = ThumbnailImageGridLine(rowIndex: lines.count, imageEntity: imageEntity, containerWidth: width, properHeight: properHeight, spacing: spacing)
            } else if (lastLine!.isFullAfterAppend(imageEntity: imageEntity)) {
                self.lines.append(lastLine!)
                lastLine = ThumbnailImageGridLine(rowIndex: lines.count, imageEntity: imageEntity, containerWidth: width, properHeight: properHeight, spacing: spacing)
            }
        }
        if (lastLine != nil) {
            lastLine!.end()
            self.lines.append(lastLine!)
        }
        // layout item
        var y: CGFloat = spacing
        var index = 0
        for (_, line) in self.lines.enumerated() {
            var x: CGFloat = line.spacing
            let h: CGFloat = line.rowHeight
            for (_, entity) in line.imageEntities.enumerated() {
                let w = entity.size.width / entity.size.height * h
                let frame = NSMakeRect(x, y, w, h)
                x += w + spacing
                let indexPath = IndexPath(item: index, section: 0)
                let attrs = ThumbnailImageLayoutAttributes(forItemWith: indexPath)
                attrs.frame = frame
                attrs.size = frame.size
                attrs.zIndex = 10
                attrs.imageEntity = entity
                cachedAttributes.append(attrs)
                maxWidth = max(maxWidth, frame.maxX)
                maxHeight = max(maxWidth, frame.maxY)
                index += 1
                print(indexPath, frame)
            }
            y += h + line.spacing
        }
        maxHeight += spacing
    }
    
    override var collectionViewContentSize: NSSize {
        return NSSize(width: maxWidth, height: maxHeight)
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        let res = cachedAttributes.filter { (attr) -> Bool in
            return attr.frame.intersects(rect)
        }
        return res
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let res = cachedAttributes.first
        return res
    }
}
