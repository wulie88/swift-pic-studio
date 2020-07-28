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

enum ImageCollectionFlowLayoutType {
    case ImageCollectionFlowLayoutTypeAutoFit
    case ImageCollectionFlowLayoutTypeWaterfall
}

class ImageCollectionFlowLayout: NSCollectionViewFlowLayout {

    var cachedAttributes: [ThumbnailImageLayoutAttributes] = []
    
    var items: [DesktopFileEntity]?
    var maxWidth: CGFloat = 0
    var maxHeight: CGFloat = 0
    var properCols: Int = 3
    let spacing: CGFloat = 10
    var type: ImageCollectionFlowLayoutType = .ImageCollectionFlowLayoutTypeWaterfall
    
    func setup(items: [DesktopFileEntity]) {
        self.items = items
    }
    
    func imageEntity(withIndexPath indexPath:IndexPath) -> DesktopFileEntity? {
        return cachedAttributes[indexPath.item].imageEntity
    }
    
    override func prepare() {
        if (type == .ImageCollectionFlowLayoutTypeAutoFit) {
            clacAutofitLayout()
        } else {
            clacWaterfallLayout()
        }
    }
    
    var lines: [ThumbnailImageGridLine] = []
    func clacAutofitLayout() {
        maxWidth = 0
        maxHeight = 0
        let width = collectionView?.frame.width ?? 0
        
        // layout line
        let properHeight:CGFloat = width / CGFloat(properCols)
        var lastLine:ThumbnailImageGridLine? = nil
        self.lines.removeAll()
        self.cachedAttributes.removeAll()
        for (_, imageEntity) in self.items!.enumerated() {
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
            }
            y += h + line.spacing
        }
        maxHeight += spacing
    }
    
    var colsHeight: [CGFloat] = []
    func clacWaterfallLayout() {
        maxWidth = 0
        maxHeight = 0
        let width = collectionView?.frame.width ?? 0
        
        // layout line
        let properWidth:CGFloat = (width - CGFloat(properCols + 1) * spacing) / CGFloat(properCols)
        self.colsHeight = [CGFloat](repeating: spacing, count: properCols)
        self.cachedAttributes.removeAll()
        for (index, imageEntity) in self.items!.enumerated() {
            let size = imageEntity.size
            let scaledSize = NSMakeSize(properWidth, size.height / size.width * properWidth)
            var colIndex = 0
            // 找到最短的列
            var minHeight:CGFloat = colsHeight[0]
            for idx in 1 ... colsHeight.count-1 {
                let height = colsHeight[idx]
                if (height <= minHeight) {
                    colIndex = idx
                    minHeight = height
                    break
                }
            }
            let x = CGFloat(colIndex + 1) * spacing + CGFloat(colIndex) * properWidth
            let frame = NSMakeRect(x, colsHeight[colIndex], scaledSize.width, scaledSize.height)
            colsHeight[colIndex] += scaledSize.height + spacing
            let indexPath = IndexPath(item: index, section: 0)
            let attrs = ThumbnailImageLayoutAttributes(forItemWith: indexPath)
            attrs.frame = frame
            attrs.size = frame.size
            attrs.zIndex = 10
            attrs.imageEntity = imageEntity
            cachedAttributes.append(attrs)
            maxHeight = max(maxHeight, colsHeight[colIndex])
        }
        maxWidth = width
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
