//
//  ImageCollectionItem.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol ImageCollectionItemDelegate : NSObjectProtocol {
    
    func itemDidDoubleClick(imageEntity: DesktopFileEntity, indexPath: IndexPath)
}
     
class ImageCollectionItem: NSCollectionViewItem {
    
    weak var imageEntity: DesktopFileEntity?
    var indexPath: IndexPath?
    
    weak open var delegate: ImageCollectionItemDelegate?
    
    @IBOutlet weak var clickGestureRecognizer: NSClickGestureRecognizer!
    
    let normalBorderColor = NSColor.clear.cgColor
    let selectedBorderColor = NSColor.init(white: 1, alpha: 1).cgColor
    
    dynamic override var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            view.needsLayout = true
            imageEntity?.isSelected = newValue
        }
    }
    
    @IBAction func doubleClick(sender: Any) {
        guard (imageEntity != nil && indexPath != nil) else {
            return
        }
        
        delegate?.itemDidDoubleClick(imageEntity: imageEntity!, indexPath: indexPath!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        clickGestureRecognizer.delaysPrimaryMouseButtonEvents = false
        
        imageView!.imageAlignment = .alignCenter
        imageView!.imageScaling = .scaleProportionallyDown
        imageView!.layer?.cornerRadius = 6
        imageView!.layer?.masksToBounds = true
        imageView!.layer?.borderColor = normalBorderColor
        imageView!.layer?.borderWidth = 2
    }
    
    func setImageEntity(imageEntity: DesktopFileEntity) {
        self.imageEntity = imageEntity
        imageView!.image = imageEntity.thumbnailImage
        self.isSelected = imageEntity.isSelected
        
        imageEntity.addObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath, options: .new, context: nil)
        imageEntity.load()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        imageView!.layer?.borderColor = self.isSelected ? selectedBorderColor : normalBorderColor
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == DesktopFileEntity.ThumbnailImageLoadedKeyPath) {
            let imageEntity = object as! DesktopFileEntity
            DispatchQueue.main.async {
                self.imageView!.image = imageEntity.thumbnailImage
            }
        }
    }
    
    deinit {
        self.imageEntity?.removeObserver(self, forKeyPath: DesktopFileEntity.ThumbnailImageLoadedKeyPath)
    }
}
