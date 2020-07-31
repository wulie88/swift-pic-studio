//
//  FolderWindowController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class FolderViewController: NSViewController, ImageCollectionViewDelegate {
    
    var folder: String?
    
    var items: [DesktopFileEntity] = []
    
    
    /// 分类面板
    @IBOutlet weak var catalogueListView: CatalogueListView!
    
    /// 缩略图面板
    @IBOutlet weak var collectionView: ImageCollectionView!
    
    /// 详情面板
    @IBOutlet weak var datasheetEditerView: DatasheetEditerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(openFolder), name: NSNotification.Name(rawValue: "openFolder"), object: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if (folder != nil) {
            loadData(path: folder!)
        }
        catalogueListView.setup(catalogs: CatalogueEntity.BuildBySummary())
    }
    
    func loadData(path: String) {
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
    
    func presentImageEditer(items: [DesktopFileEntity], currentIndex: Int, sender: NSView) {
        let vc = (NSStoryboard.main?.instantiateController(withIdentifier:NSStoryboard.SceneIdentifier("EditerViewController"))) as! EditerViewController
        vc.setup(items: items, currentIndex: currentIndex)
        
        presentAsModalWindow(vc)
    }
    
    func updateSelectItems(items: Array<DesktopFileEntity>) {
        datasheetEditerView.setup(newSelectedItems: items)
    }
    
    @objc func openFolder(noti: Notification) {
        let path = noti.object as! String
        
        
        let vc = (NSStoryboard.main?.instantiateController(withIdentifier:NSStoryboard.SceneIdentifier("FolderViewController"))) as! FolderViewController
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

