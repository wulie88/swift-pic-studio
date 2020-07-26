//
//  DesktopEntity.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/26.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class DesktopEntity: NSObject {
    
    var fileUrl: URL
    
    static func entityForPath(path:String) -> DesktopEntity? {
        let fileManager = FileManager()
        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            return nil
        }
        
        return isDir.boolValue ? DesktopFolderEntity(path: path) : DesktopFileEntity(path: path)
    }

    init(path:String) {
        self.fileUrl = URL(fileURLWithPath: path)
        super.init()
    }
}

class DesktopFileEntity: DesktopEntity {
    
    static var ThumbnailImageLoadedKeyPath = "thumbnailImage"
    
    var size = CGSize.zero
    var type = ScoutedImageType.unsupported
    @objc dynamic var image: NSImage?
    @objc dynamic var thumbnailImage: NSImage?
    var loading = false
    
    override init(path: String) {
        super.init(path: path)
        
        var attrs = try? FileManager.default.attributesOfItem(atPath: path)
        var fileHandle = FileHandle(forReadingAtPath: path)
        if (attrs != nil &&  fileHandle != nil) {
            let dict = attrs! as NSDictionary
            var header = fileHandle!.readData(ofLength: 2048)
            var type = ImageParser.imageType(with: header)
            self.type = type
            if type != .unsupported {
                self.size = ImageParser.imageSize(with: header)
//                var read: UInt64 = 2048
//                while (type == .jpeg && self.size == CGSize.zero && read < dict.fileSize()) {
//                    do {
//                        try fileHandle!.seek(toOffset: read)
//                        header.append(fileHandle!.readData(ofLength: 2048*1000))
//                        self.size = ImageParser.imageSize(with: header)
//                        read += 2048*1000
//                    } catch {
//                        break
//                        print(error)
//                    }
//                }
                print(path, self.size)
            }
            fileHandle!.closeFile()
        }
    }
    
    static let sharedOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
        return queue
    } ()
    
    static func ThumbnailImageFromImage(image: NSImage) -> NSImage {
        let imageSize = image.size;
        let imageAspectRatio = imageSize.width / imageSize.height;
        // Create a thumbnail image from this image (this part of the slow operation).
        let thumbnailSize = NSMakeSize(400 * imageAspectRatio, 400);
        let thumbnailImage = NSImage(size: thumbnailSize);
        thumbnailImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height), from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        thumbnailImage.unlockFocus()
        
        return thumbnailImage
    }
    
    func load() {
        if (!self.loading) {
            self.loading = true
            
            DesktopFileEntity.sharedOperationQueue.addBarrierBlock {
                let image = NSImage(contentsOf: self.fileUrl)
                self.loading = false
                if (image != nil) {
                    self.thumbnailImage = DesktopFileEntity.ThumbnailImageFromImage(image: image!)
                } else {
                    self.image = NSImage(named: NSImage.trashFullName)
                }
            }
        }
    }
}

class DesktopFolderEntity: DesktopEntity {
    
    lazy var children:[DesktopEntity] = {
        var items:[DesktopEntity] = []
        do {
            var urls = try FileManager.default.contentsOfDirectory(at: self.fileUrl, includingPropertiesForKeys: nil)
            for var url in urls {
                var path = url.relativePath
                var entity = DesktopEntity.entityForPath(path: path)
                if entity != nil {
                    items.append(entity!)
                }
            }
        } catch {
            print(error)
        }
        return items
    }()
}
