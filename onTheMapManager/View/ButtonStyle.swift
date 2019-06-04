//
//  ButtonStyle.swift
//  onTheMap
//
//  Created by Asmahero on ١٥ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//**** it is just a try to implement custom style

import Foundation
import UIKit
class ButtonStyle: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
}
}
