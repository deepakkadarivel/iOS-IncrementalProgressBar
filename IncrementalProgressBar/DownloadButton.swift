//
//  DownloadButton.swift
//  IncrementalProgressBar
//
//  Created by Deepak Kadarivel on 29/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

class DownloadButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 8.0
        
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }

}
