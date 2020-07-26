//
//  ThumbnailImageGridView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ThumbnailImageGridView: NSStackView {
    
    var lines: [NSRange] = []
    var items: [DesktopEntity] = []
    
    @IBOutlet weak var tableView: NSTableView!
    
    func updateItems(items: [DesktopEntity]) {
        self.items = items
        self.needsLayout = true
    }
    
    override func layout() {
        super.layout()
        
        // layout
        let h:CGFloat = 200.0
        let width = self.frame.width
        var layoutWidth:CGFloat = 0
        var lastIndex = 0
        self.lines.removeAll()
        for (index, entity) in self.items.enumerated() {
            if !entity.isMember(of: DesktopFileEntity.self) {
                continue
            }
            
            let imageEntity = entity as! DesktopFileEntity
            let size = imageEntity.size
            if (size == CGSize.zero) {
                continue
            }
            
            let scaledSize = NSMakeSize(size.width / size.height * h, h)
            layoutWidth += scaledSize.width
            if (layoutWidth > width) {
                let range = NSMakeRange(lastIndex, index-lastIndex-1)
                lastIndex = index - 1
                layoutWidth = scaledSize.width
                self.lines.append(range)
                print("append", range)
            }
            print(index, layoutWidth, width, scaledSize, lines.count)
        }
        self.tableView.reloadData()
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
        
        let range = self.lines[row]
        print("range", row, range)
        let imageEntities = Array(self.items[range.location ... range.location+range.length-1])
        gridCell.setImages(images: imageEntities)
        
        return gridCell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 200.0
    }
}
