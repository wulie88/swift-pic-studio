//
//  CatalogueListView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/29.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

/**
 目录列表
 */
class CatalogueListView: NSView {
    
    var catalogs: [CatalogueEntity] = []
    var currentCatalog:CatalogueEntity?
    
    @IBOutlet weak var folderMenu: NSMenu!
    @IBOutlet weak var smartMenu: NSMenu!
    
    @IBOutlet weak var outlineView: MenuOutlineView!

    func setup(catalogs: [CatalogueEntity]) {
        self.catalogs = catalogs
        
        wantsLayer = true
        layer?.cornerRadius = 6
        layer?.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMaxXMinYCorner]
        layer?.masksToBounds = true
        layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.1).cgColor
//        layer?.shadowOpacity = 10.0
//        layer?.shadowColor = NSColor.white.cgColor
//        layer?.shadowOffset = NSMakeSize(-3, -3)
        outlineView.backgroundColor = NSColor.clear
        outlineView.menuDelegate = self
        outlineView.setDraggingSourceOperationMask(.move, forLocal: false)
        outlineView.registerForDraggedTypes([.string, .png])
        
        outlineView.reloadData()
    }
    
//    override func draw(_ dirtyRect: NSRect) {
//        let sourceImage: CIImage? = FolderViewController.sharedBlurredBackgroundImage
//        let sourceFrame: NSRect? = FolderViewController.sharedBackgroundFrame
//        guard sourceImage != nil else {
//            return
//        }
//
//        sourceImage!.draw(in: dirtyRect, from: frame, operation: .copy, fraction: 1)
//    }
}

extension CatalogueListView : NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        let entity = item as? CatalogueEntity
        if entity == nil {
            return catalogs.count
        } else {
            return entity!.children.count
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        let entity = item as? CatalogueEntity
        if entity == nil {
            return catalogs[index]
        } else {
            return entity!.children[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let entity = item as? CatalogueEntity else {
            return false
        }
        return entity.isExpanding
    }
    
    
    // MARK: Drag and drop
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let entity = item as! CatalogueEntity
        if entity.level == 0 {
            return nil
        }
        
        return entity.indentifier as NSString
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        guard let entity = item as! CatalogueEntity? else {
            return .every
        }
        
        print("validateDrop", entity.name, index)
        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        let entity = item as? CatalogueEntity
        print("acceptDrop", entity?.name ?? "", index)
        return false
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        guard let entity = notification.userInfo?["NSObject"] as? CatalogueEntity else {
            return
        }
        
        entity.isExpanding = true
    }
    
    func outlineViewItemDidCollapse(_ notification: Notification) {
        guard let entity = notification.userInfo?["NSObject"] as? CatalogueEntity else {
            return
        }
        
        entity.isExpanding = false
    }
}

extension CatalogueListView : NSOutlineViewDelegate {
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let entity = item as! CatalogueEntity
        if entity.isTitled {
            guard let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CatalogueTitledCellView"), owner: self) as? CatalogueTitledCellView else {
                return nil
            }
            
            cellView.setCatalogueEntity(entity)
            cellView.delegate = self
            
            return cellView
        } else {
            guard let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CatalogueCellView"), owner: self) as? CatalogueCellView else {
                return nil
            }
            
            cellView.setCatalogueEntity(entity)
            cellView.delegate = self
            
            return cellView
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        let entity = item as! CatalogueEntity
        return entity.isTitled ? 44 : 30
    }

}

extension CatalogueListView : CatalogueTitledCellViewDelegate {
    
    func cell(cell: CatalogueTitledCellView, addButtonDidClick button: NSButton) {
        let item = cell.entity!
        if item.name == "smart" {
            
        } else {
            let newItem = CatalogueEntity(name: "_", title: "新项目")
            appendItem(item: newItem, inParent: item)
        }
    }
    
    func appendItem(item newItem: CatalogueEntity, inParent parent: CatalogueEntity) {
        let index = parent.children.count
        parent.insert(newItem, at: index)
        let indexSet = IndexSet([index])
        outlineView.insertItems(at: indexSet, inParent: parent, withAnimation: .slideUp)
        outlineView.expandItem(parent)
        let row = outlineView.row(forItem: newItem)
        outlineView.selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
        guard let view = outlineView.view(atColumn: 0, row: row, makeIfNecessary: false) else {
            return
        }
        view.window?.makeFirstResponder(view)
    }
}

extension CatalogueListView : CatalogueCellViewDelegate {
    
    func cell(cell: CatalogueTitledCellView, titleFieldDidChange textField: NSTextField) {
        
    }
}

extension CatalogueListView : MenuOutlineViewDelegate, NSMenuDelegate {
    
    func outlineView(_ outlineView: MenuOutlineView, menuForItem item: Any?, atRow index: Int) -> NSMenu? {
        guard let entity = item as? CatalogueEntity else {
            return nil
        }
        // 设置当前
        currentCatalog = entity
        
        if (entity.level == 0) {
            return nil
        }
        
        return entity.isSmart ? smartMenu : folderMenu
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
    }
    
    // MARK: 智能文件夹事件
    
    // 新建智能文件夹
    @IBAction func newSmart(menuItem: NSMenuItem) {
        
    }
    
    // 重命名
    @IBAction func renameSmart(menuItem: NSMenuItem) {
        
    }
    
    // 修改规则
    @IBAction func editSmart(menuItem: NSMenuItem) {
        
    }
    
    // 克隆
    @IBAction func cloneSmart(menuItem: NSMenuItem) {
        
    }
    
    // 导出
    @IBAction func exportSmart(menuItem: NSMenuItem) {
        
    }
    
    // 删除
    @IBAction func deleteSmart(menuItem: NSMenuItem) {
        
    }
    
    // MARK: 文件夹事件
    
    // 新建文件夹
    @IBAction func newFolder(menuItem: NSMenuItem) {
        guard let parent = currentCatalog?.perent else {
            return
        }
        let newItem = CatalogueEntity(name: "_", title: "新项目")
        appendItem(item: newItem, inParent: parent)
    }
    
    // 新建子文件夹
    @IBAction func newSubFolder(menuItem: NSMenuItem) {
        guard let parent = currentCatalog else {
            return
        }
        let newItem = CatalogueEntity(name: "_", title: "新项目")
        appendItem(item: newItem, inParent: parent)
    }
    
    // 移动文件夹
    @IBAction func moveFolder(menuItem: NSMenuItem) {
        
    }
    
    // 重命名
    @IBAction func renameFolder(menuItem: NSMenuItem) {
        let row = outlineView.row(forItem: currentCatalog)
        outlineView.selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
        guard let view = outlineView.view(atColumn: 0, row: row, makeIfNecessary: false) else {
            return
        }
        view.window?.makeFirstResponder(view)
    }
    
    // 设置自动标签
    @IBAction func configTagFolder(menuItem: NSMenuItem) {
        
    }
    
    // 展开/收起文件夹
    @IBAction func expandFolder(menuItem: NSMenuItem) {
        guard let currentCatalog = currentCatalog else {
            return
        }
        
        if currentCatalog.isExpanding {
            outlineView.collapseItem(currentCatalog)
        } else {
            outlineView.expandItem(currentCatalog)
        }
    }
    
    // 展开/收起同层级文件夹
    @IBAction func expandChildrenFolder(menuItem: NSMenuItem) {
        
    }
    
    // 展开/收起所有文件夹
    @IBAction func expandAllFolder(menuItem: NSMenuItem) {
        
    }
    
    // 导出
    @IBAction func exportFolder(menuItem: NSMenuItem) {
        
    }
    
    // 显示所有子文件夹内容
    @IBAction func showAllContents(menuItem: NSMenuItem) {
        
    }
    
    // 删除
    @IBAction func deleteFolder(menuItem: NSMenuItem) {
        guard let currentCatalog = currentCatalog else {
            return
        }
        guard let row = currentCatalog.perent?.children.firstIndex(of: currentCatalog) else {
            return
        }
        
        outlineView.removeItems(at: IndexSet([row]), inParent: currentCatalog.perent, withAnimation: .slideDown)
        let _ = currentCatalog.perent?.remove(currentCatalog)
    }
}
