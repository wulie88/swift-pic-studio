//
//  ViewController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var items: [DesktopEntity] = []
    
    @IBOutlet weak var gridView: ThumbnailImageGridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager()
        
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.downloadsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        if urls.count>0 {
            let picturesURL = urls.last!.appendingPathComponent("2018-02-11 T031 年年尤果")
            let path = picturesURL.relativePath
            

            let entity = DesktopFolderEntity(path: path)
            self.items = entity.children.filter({ (entity) -> Bool in
                if !entity.isMember(of: DesktopFileEntity.self) {
                    return false
                }
                
                let imageEntity = entity as! DesktopFileEntity
                return imageEntity.size != CGSize.zero
            })
            
            
            self.gridView.updateItems(items: items)
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

