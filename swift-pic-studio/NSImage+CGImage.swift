//
//  NSImage+CGImage.swift
//  swift-pic-studio
//
//  Created by boss on 2020/8/2.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

extension NSImage {
    @objc var CGImage: CGImage? {
       get {
            guard let imageData = self.tiffRepresentation else { return nil }
            guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
            return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
       }
    }
}
