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
    
    func flowLayout(didSort sort: ImageCollectionFlowLayoutSort, byOrder order: ImageCollectionFlowLayoutOrder)
}

class ImageCollectionToolbar: NSView {
    
    var type: ImageCollectionFlowLayoutType?
    
    weak open var delegate: ImageCollectionToolbarDelegate?
    
    @IBOutlet weak var arrowlocationControl: NSSegmentedControl!
    
    @IBOutlet weak var typeToggleControl: NSSegmentedControl!
    
    @IBOutlet weak var orderToggleControl: NSSegmentedControl!

    func setup(type: ImageCollectionFlowLayoutType) {
        self.type = type
    }
    
    @IBAction func sliderValueChanged(slider: NSSlider) {
        let step: Float = 1
        let roundedValue = round(slider.floatValue/step) * step
        slider.floatValue = roundedValue
        delegate?.properColsDidChanged(properCols: Int(roundedValue))
    }
    
    @IBAction func arrowlocationClicked(control: NSSegmentedControl) {
        if control == arrowlocationControl {
            let arrow = control.selectedSegment
            print("arrowlocationControl", arrow)
        } else if control == typeToggleControl {
            let type = control.selectedSegment == 0 ? ImageCollectionFlowLayoutType.waterfall : ImageCollectionFlowLayoutType.autoFit
            delegate?.flowLayoutTypeDidChanged(type: type)
        }
    }
    
    @IBAction func orderClicked(control: NSSegmentedControl) {
        if (control.selectedSegment == 0) {
            delegate?.flowLayout(didSort: .creationDate, byOrder: .desc)
        } else if (control.selectedSegment == 1) {
            delegate?.flowLayout(didSort: .creationDate, byOrder: .asc)
        } else if (control.selectedSegment == 2) {
            delegate?.flowLayout(didSort: .filename, byOrder: .asc)
        }
    }
}
