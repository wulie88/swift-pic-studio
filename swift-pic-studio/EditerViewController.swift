//
//  EditerViewController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/1.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class EditerViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    
    var currentEntity: DesktopFileEntity?
    
    func setup(items: [DesktopFileEntity], currentIndex: Int) {
        currentEntity = items[currentIndex]
    }
    
    override func loadView() {
        super.loadView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        imageView.image = currentEntity!.thumbnailImage
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.setContentSize(NSSize(width: 1000, height: 800))
    }
    
}
