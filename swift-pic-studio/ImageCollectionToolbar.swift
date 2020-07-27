//
//  ImageCollectionToobar.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/28.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class ImageCollectionToolbar: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func sliderValueChanged(slider: NSSlider) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sliderValueChanged"), object: slider, userInfo: nil)
    }
}
