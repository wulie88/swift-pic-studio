//
//  FastImageSize.swift
//  swift-pic-studio
//
//  Created by Leo Wu on 2020/7/30.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class FastImageSize: NSObject {
    enum ImageType : String {
      case gif
      case png
      case jpeg
      case unsupported
    }
    
    private struct PNGSize {
      var width: UInt32 = 0
      var height: UInt32 = 0
    }
    
    private struct GIFSize {
      var width: UInt16 = 0
      var height: UInt16 = 0
    }
    
    private struct JPEGSize {
      var height: UInt16 = 0
      var width: UInt16 = 0
    }
    
    static func Parse(path: String) {
        var imageType: ImageType = .unsupported
        var size: CGSize = CGSize.zero
        let fileHandle = FileHandle(forReadingAtPath: path)
        if (fileHandle != nil) {
            do {
                let header = try fileHandle?.read(upToCount: 26)
                if (header!.count >= 10 && ["GIF87a".data(using: .utf8), "GIF89a".data(using: .utf8)].contains(header!.subdata(in: 0..<6))) {
                    imageType = .gif
                    size = self.sizeForGIF(header!)
                }
            } catch var err {
                print("FastImageSize.Parse", err)
            }
        }
    }
    
    // MARK: GIF

    static func sizeForGIF(_ data: Data) -> CGSize {
      if (data.count < 11) { return CGSize.zero }
      
      var size = GIFSize()
        (data as NSData).getBytes(&size, range: NSRange(location: 6, length: 4))
      
      return CGSize(width: Int(size.width), height: Int(size.height))
    }
}
