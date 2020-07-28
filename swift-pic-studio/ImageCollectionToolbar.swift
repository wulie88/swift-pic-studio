//
//  ImageCollectionToobar.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/28.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

protocol ImageCollectionToolbarDelegate : NSObjectProtocol {
    
    func properColsDidChanged(properCols: Int)
    
    func flowLayoutTypeDidChanged(type: ImageCollectionFlowLayoutType)
}

class ImageCollectionToolbar: NSView {
    
    var type: ImageCollectionFlowLayoutType?
    
    weak open var delegate: ImageCollectionToolbarDelegate?

    func setup(type: ImageCollectionFlowLayoutType) {
        self.type = type
    }
    
    @IBAction func sliderValueChanged(slider: NSSlider) {
        let step: Float = 1
        let roundedValue = round(slider.floatValue/step) * step
        slider.floatValue = roundedValue
        delegate?.properColsDidChanged(properCols: Int(roundedValue))
    }
    
    @IBAction func typeButtonDidClick(button: NSButton) {
        let type = self.type == ImageCollectionFlowLayoutType.ImageCollectionFlowLayoutTypeAutoFit ? ImageCollectionFlowLayoutType.ImageCollectionFlowLayoutTypeWaterfall : ImageCollectionFlowLayoutType.ImageCollectionFlowLayoutTypeAutoFit
        delegate?.flowLayoutTypeDidChanged(type: type)
        self.type = type
    }
}
