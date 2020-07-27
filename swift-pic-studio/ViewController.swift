//
//  ViewController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var items: [DesktopFileEntity] = []
    
    @IBOutlet weak var collectionView: ImageCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager()
        
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.downloadsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        if urls.count>0 {
            let picturesURL = urls.last!.appendingPathComponent("2017-12-06 U326 糖果")
            let path = picturesURL.relativePath
            

            let entity = DesktopFolderEntity(path: path)
            let items = entity.children.filter({ (entity) -> Bool in
                if !entity.isMember(of: DesktopFileEntity.self) {
                    return false
                }
                
                let imageEntity = entity as! DesktopFileEntity
                return imageEntity.size != CGSize.zero
            })
            
            self.items = items as! [DesktopFileEntity]
            collectionView.updateItems(items: self.items)
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

