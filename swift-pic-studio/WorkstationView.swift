//
//  WorkstationView.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/27.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class WorkstationView: NSStackView {
    
    var filePath: String?
    let expectedExt = ["kext"]
    let bgImage = NSImage(named: "bg")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
              let path = board[0] as? String
        else { return false }
        
        let fileManager = FileManager()
        
        var isDir: ObjCBool = false
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        if (isDir.boolValue) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openFolder"), object: path, userInfo: nil)
            return true
        }
        
        return false
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        bgImage?.draw(in: dirtyRect)
//        //获取原始图片
//        originalImage?.cgImage(forProposedRect: <#T##UnsafeMutablePointer<NSRect>?#>, context: <#T##NSGraphicsContext?#>, hints: <#T##[NSImageRep.HintKey : Any]?#>)
//        let inputImage = CIImage(image: originalImage)
//        //使用高斯模糊滤镜
//        let filter = CIFilter(name: "CIGaussianBlur")!
//        filter.setValue(inputImage, forKey:kCIInputImageKey)
//        //设置模糊半径值（越大越模糊）
//        filter.setValue(10, forKey: kCIInputRadiusKey)
//        let outputCIImage = filter.outputImage!
//        let rect = CGRect(origin: CGPoint.zero, size: originalImage.size)
        
    }
    
}
