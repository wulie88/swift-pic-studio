//
//  ThumbnailImageGridView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

struct ThumbnailImageGridLine {
    var rowIndex: Int = 0
    var rowHeight: CGFloat = 0
    var layoutWidth: CGFloat = 0
    var imageEntities: [DesktopFileEntity] = []
    var containerWidth: CGFloat
    var properHeight: CGFloat
    var spacing: CGFloat
    
    init(rowIndex: Int, imageEntity:DesktopFileEntity, containerWidth: CGFloat, properHeight: CGFloat, spacing: CGFloat) {
        self.containerWidth = containerWidth
        self.properHeight = properHeight
        self.rowIndex = rowIndex
        self.spacing = spacing
        let size = imageEntity.size
        self.rowHeight = min(size.height, properHeight)
        self.layoutWidth = size.width / size.height * rowHeight
        self.imageEntities.append(imageEntity)
    }
    
    mutating func isFullAfterAppend(imageEntity:DesktopFileEntity) -> Bool {
        let size = imageEntity.size
        let scaledSize = NSMakeSize(size.width / size.height * rowHeight, rowHeight)
        if (layoutWidth > containerWidth) {
            let contentWidth = containerWidth - spacing * CGFloat(imageEntities.count + 1)
            rowHeight = rowHeight / layoutWidth * contentWidth
            return true
        }
        
        layoutWidth += scaledSize.width
        self.imageEntities.append(imageEntity)
        return false
    }
}

class ThumbnailImageGridView: NSView {
    
    var lines: [ThumbnailImageGridLine] = []
    var items: [DesktopFileEntity] = []
    
    @IBOutlet weak var tableView: NSTableView!
    
    func updateItems(items: [DesktopFileEntity]) {
        self.items = items
        self.needsLayout = true
    }
    
    override func layout() {
        super.layout()
        
        // layout
        let width = self.frame.width
        let properHeight:CGFloat = width / 3
        let spacing:CGFloat = 20
        var lastLine:ThumbnailImageGridLine? = nil
        self.lines.removeAll()
        for (_, entity) in self.items.enumerated() {
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
        
//        self.tableView.reloadData()
    }
}

extension ThumbnailImageGridView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.lines.count
    }
}

extension ThumbnailImageGridView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let gridCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThumbnailImageGridCell"), owner: self) as? ThumbnailImageGridCell else {
            return nil
        }
        
        let line = self.lines[row]
        gridCell.setLine(line: line)
        
        return gridCell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let line = self.lines[row]
        return line.rowHeight
    }
}
