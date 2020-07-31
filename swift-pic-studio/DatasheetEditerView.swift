//
//  DatasheetEditerView.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/29.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class DatasheetEditerView: NSView {
    
    var selectedItems: Array<DesktopFileEntity> = []
    
    @IBOutlet weak var tabView: NSTabView!
    /// 分类
    
    /// 已选定
    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var fileSizeLabel: NSTextField!
    @IBOutlet weak var createDateLabel: NSTextField!

    func setup(newSelectedItems:Array<DesktopFileEntity>) {
        tabView.selectTabViewItem(at: 1)
        
        guard let last = newSelectedItems.last else {
            return
        }
        
        coverImageView.image = last.thumbnailImage
        fileNameLabel.stringValue = last.filename as! String
        
        var attrs = last.attrs as! NSDictionary
        fileSizeLabel.integerValue = Int(attrs.fileSize())
        createDateLabel.stringValue = attrs.fileCreationDate()?.description as! String
    }
    
}
