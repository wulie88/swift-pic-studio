/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A sample model object. A base abstract class (ATDesktopEntity) implements caching of a file URL. One concrete subclass implements the ability to have an array of children (ATDesktopFolderEntity). Another (ATDesktopImageEntity) represents an image suitable for the desktop wallpaper.
 */

//#import "ATDesktopEntity.h"

import Quartz; // for IKImageBrowserNSURLRepresentationType

// define THUMBNAIL_HEIGHT 180.0 

// For the purposes of a demo, we intentionally make things slower.
// Turning off the DEMO_MODE define will make things run at normal speed.
// define DEMO_MODE 0

let ATEntityPropertyNamedThumbnailImage:String! = "thumbnailImage"


    // MARK: -

class ATDesktopEntity : NSObject {

    var title:String!
    private var _fileURL:NSURL!
    var fileURL:NSURL! {
        get { return _fileURL }
        set { _fileURL = newValue }
    }

    class func entityForURL(url:NSURL!) -> ATDesktopEntity! {
        // We create folder items or image items, and ignore everything else; all based on the UTI we get from the URL.
        var typeIdentifier:String!
        if url.getResourceValue(&typeIdentifier, forKey: NSURLTypeIdentifierKey) {
            let imageUTIs:[AnyObject]! = NSImage().imageTypes
            if imageUTIs.containsObject(typeIdentifier) {
                return ATDesktopImageEntity(fileURL:url)
            } else if (typeIdentifier == (kUTTypeFolder as! NSString)) {
                return ATDesktopFolderEntity(fileURL:url);;
            } 
        }
        return nil
    }

    init() {
        NSAssert(false, "Invalid use of init; use initWithFileURL to create ATDesktopEntity")
        return self.init()
    }

    init(fileURL:NSURL!) {
        self = super.init()
        _fileURL = fileURL
        return self
    }

    func copyWithZone(zone:NSZone!) -> AnyObject! {
        let result:AnyObject! = self.self(fileURL:self.fileURL)
        return result
    }

    func description() -> String! {
        return String(format:"%@ : %@", super.description, self.title)
    }

    func title() -> String! {
        var result:String!
        if self.fileURL.getResourceValue(&result, forKey:NSURLLocalizedNameKey, error:nil) {
            return result
        }
        return nil
    }


    // MARK: - NSPasteboardWriting support

    func writableTypesForPasteboard(pasteboard:NSPasteboard!) -> [AnyObject]! {
        return self.fileURL.writableTypesForPasteboard(pasteboard)
    }

    func pasteboardPropertyListForType(type:String!) -> AnyObject! {
        return self.fileURL.pasteboardPropertyListForType(type)
    }

    func writingOptionsForType(type:String!, pasteboard:NSPasteboard!) -> NSPasteboardWritingOptions {
        if self.fileURL.respondsToSelector(Selector("writingOptionsForType:pasteboard:")) {
            return self.fileURL.writingOptionsForType(type, pasteboard:pasteboard)
        } else {
            return 0
        }
    }


    // MARK: - NSPasteboardReading support

    class func readableTypesForPasteboard(pasteboard:NSPasteboard!) -> [AnyObject]! {
        // We allow creation from folder and image URLs only, but there is no way to specify just file URLs that contain images.
        return [(kUTTypeFolder as! id), (kUTTypeFileURL as! id)]
    }

    class func readingOptionsForType(type:String!, pasteboard:NSPasteboard!) -> NSPasteboardReadingOptions {
        return NSPasteboardReadingAsString
    }


    // MARK: - Image Support

    func imageUID() -> String! {
        return String(format:"%p", self)
    }

    func imageRepresentationType() -> String! {
        return IKImageBrowserNSURLRepresentationType
    }

    func imageRepresentation() -> AnyObject! {
        return self.fileURL
    }

    func imageVersion() -> UInt {
        return 0
    }

    func imageTitle() -> String! {
        return self.title
    }

    func imageSubtitle() -> String! {
        return nil
    }

    func isSelectable() -> Bool {
        return true
    }
}


    // MARK: -


class ATDesktopImageEntity : ATDesktopEntity {

    private var _imageLoading:Bool
    private var _image:NSImage!
    private var _thumbnailImage:NSImage!
    private var _fillColor:NSColor!
    private var _fillColorName:String!
    private var _fillColor:NSColor!
    var fillColor:NSColor! {
        get { return _fillColor }
        set { _fillColor = newValue }
    }
    private var _fillColorName:String!
    var fillColorName:String! {
        get { return _fillColorName }
        set { _fillColorName = newValue }
    }
    private var _fastImage:FastImage!
    var fastImage:FastImage! {
        get { return _fastImage }
        set { _fastImage = newValue }
    }
    private var _image:NSImage!
    var image:NSImage! {
        get { return _image }
        set { _image = newValue }
    }
    private(set) var thumbnailImage:NSImage!
    private var _imageLoading:Bool
    var imageLoading:Bool {
        get { return _imageLoading }
    }


    override init(fileURL:NSURL!) {
        self = super.init(fileURL:fileURL)
        if self != nil  {
            // Initialize our color to specific given color for testing purposes.
            var lastColorIndex:UInt = 0
            let colorList:NSColorList! = NSColorList.colorListNamed("Crayons")
            let keys:[AnyObject]! = colorList.allKeys
            if lastColorIndex >= keys.count {
                lastColorIndex = 0
            }
            _fillColorName = keys[lastColorIndex++]
            _fillColor = colorList(key:_fillColorName)

            _fastImage = FastImage(path:fileURL.relativePath)
            _fastImage.recognize()
        }
        return self
    }

    func ATThumbnailImageFromImage(image:NSImage!) -> NSImage! {
        let imageSize:NSSize = image.size
        let imageAspectRatio:CGFloat = imageSize.width / imageSize.height
        // Create a thumbnail image from this image (this part of the slow operation).
        let thumbnailSize:NSSize = NSMakeSize(THUMBNAIL_HEIGHT * imageAspectRatio, THUMBNAIL_HEIGHT)
        let thumbnailImage:NSImage! = NSImage(size:thumbnailSize)
        thumbnailImage.lockFocus()
        image.drawInRect(NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height), fromRect:NSZeroRect, operation:NSCompositingOperationSourceOver, fraction:1.0)                
        thumbnailImage.unlockFocus()

#if DEMO_MODE
        // We delay things with an explicit sleep to get things slower for the demo!
        usleep(250000)
#endif

        return thumbnailImage
    }

    // Lazily load the thumbnail image when requested.
    func thumbnailImage() -> NSImage! {
        if self.image != nil && _thumbnailImage == nil {
            // Generate the thumbnail right now, synchronously.
            _thumbnailImage = ATThumbnailImageFromImage(self.image)
        } else if self.image == nil && !self.imageLoading {
            // Load the image lazily.
            self.loadImage()
        }        
        return _thumbnailImage
    }

    func setThumbnailImage(img:NSImage!) {
        if img != _thumbnailImage {
            _thumbnailImage = img
        }
    }

    func ATSharedOperationQueue() -> NSOperationQueue! {
        var _ATSharedOperationQueue:NSOperationQueue! = nil
        if _ATSharedOperationQueue == nil {
            _ATSharedOperationQueue = NSOperationQueue()
            // We limit the concurrency to see things easier for demo purposes.
            // The default value NSOperationQueueDefaultMaxConcurrentOperationCount will yield better results,
            // as it will create more threads, as appropriate for your processor.
            //
            _ATSharedOperationQueue.maxConcurrentOperationCount = 2
        }
        return _ATSharedOperationQueue
    }

    func loadImage() {
        $(SynchronizedStatement)
    }
}


    // MARK: -


class ATDesktopFolderEntity : ATDesktopEntity {

    private var _children:NSMutableArray!
    var children:NSMutableArray!

    $(PropertyDynamicImplementation)

    func children() -> NSMutableArray! {
        var result:NSMutableArray! = nil
        // This property is declared as atomic. We use @synchronized to ensure that promise is kept.
        $(SynchronizedStatement)
        return result
    }

    func setChildren(value:NSMutableArray!) {
        // This property is declared as atomic. We use @synchronized to ensure that promise is kept.
        $(SynchronizedStatement)
    }
}

