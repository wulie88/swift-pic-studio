//
//  ViewController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var folder: String?
    
    var items: [DesktopFileEntity] = []
    
    @IBOutlet weak var collectionView: ImageCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        let path = folder ?? defalutFolder()
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

        NotificationCenter.default.addObserver(self, selector: #selector(openFolder), name: NSNotification.Name(rawValue: "openFolder"), object: nil)
    }
    
    @objc func openFolder(noti: Notification) {
        let path = noti.object as! String
        
        
        let vc = (NSStoryboard.main?.instantiateController(withIdentifier:NSStoryboard.SceneIdentifier("ViewController"))) as! ViewController
        vc.folder = path
        
        self.presentAsModalWindow(vc)
    }
    
    func defalutFolder() -> String {
        let fileManager = FileManager()
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.downloadsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            let picturesURL = urls.last!.appendingPathComponent("example")
          return picturesURL.relativePath
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

