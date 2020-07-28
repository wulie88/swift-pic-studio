//
//  DocumentController.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/28.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class DocumentController: NSDocumentController {

    override var documentClassNames: [String] {
        return ["PicStudioDocument"];
    }
    
    override var defaultType: String? {
        return "PicStudioDocument"
    }
    
    override func documentClass(forType typeName: String) -> AnyClass? {
        return Document.self
    }
    
}
