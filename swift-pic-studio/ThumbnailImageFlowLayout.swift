//
//  ThumbnailImageFlowLayout.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ThumbnailImageFlowLayout: NSCollectionViewFlowLayout {
    
    var lines: [ThumbnailImageGridLine] = []
    var cachedAttributes: [NSCollectionViewLayoutAttributes] = []
    
    var items: [DesktopFileEntity]?
    var containerWidth: CGFloat?
    
    func setup(items: [DesktopFileEntity], containerWidth: CGFloat) {
        self.items = items
        self.containerWidth = containerWidth
    }
    
    override func prepare() {
        // layout line
        let width = self.containerWidth!
        let properHeight:CGFloat = width / 3
        let spacing:CGFloat = 20
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
            self.lines.append(lastLine!)
        }
        // layout item
        var y: CGFloat = 0
        for (row, line) in self.lines.enumerated() {
            var x: CGFloat = line.spacing
            let h: CGFloat = line.rowHeight
            for (col, entity) in line.imageEntities.enumerated() {
                let w = entity.size.width / entity.size.height * h
                let frame = NSMakeRect(x, y, w, h)
                x += w + line.spacing
                let indexPath = IndexPath(item: col, section: row)
                let item = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                item.frame = frame
                cachedAttributes.append(item)
                print(indexPath, frame)
            }
            y += h + line.spacing
        }
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var attributes = [NSCollectionViewLayoutAttributes]()
        
        // 找到在当前区域内的任何一个 Attributes 的 Index
        guard let firstMatchIndex = binarySearchAttributes(range: 0...cachedAttributes.endIndex, rect:rect) else { return attributes }
        
        // 从后向前反向遍历，缩小查找范围
        for attrs in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attrs.frame.maxY >= rect.minY  else {break}
            attributes.append(attrs)
        }
        // 从前向后正向遍历，缩小查找范围
        for attrs in cachedAttributes[firstMatchIndex...] {
            guard attrs.frame.minY <= rect.maxY  else {break}
            attributes.append(attrs)
        }
        
        return attributes
    }
    
    func binarySearchAttributes(range: CountableClosedRange<Int>, rect: CGRect) -> Int? {
        var lowerBound = 0
        var upperBound = range.count - 1
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if cachedAttributes[midIndex].frame.intersects(rect) {
                return midIndex
            } else if cachedAttributes[midIndex].frame.maxY < rect.minY {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
}
