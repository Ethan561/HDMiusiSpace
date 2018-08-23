//
//  HDLY_KeyboardView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/22.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_KeyboardView: KeyboardTextField {

    override init(frame : CGRect) {
        super.init(frame : frame)
        self.clearTestColor()
        
        //Right Button
        self.rightButton.showsTouchWhenHighlighted = true
        self.rightButton.backgroundColor = UIColor(rgb: (252,49,89))
        self.rightButton.clipsToBounds = true
        self.rightButton.layer.cornerRadius = 18
        self.rightButton.setTitle("发布", for: .normal)
        self.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        //TextView
        self.textViewBackground.layer.borderColor = UIColor(rgb: (191,191,191)).cgColor
        self.textViewBackground.backgroundColor = UIColor.HexColor(0xEEEEEE)
        self.textViewBackground.layer.cornerRadius = 18
        self.textViewBackground.layer.masksToBounds = true
        self.keyboardView.backgroundColor = UIColor.white
        self.placeholderLabel.textAlignment = .left
        self.placeholderLabel.text = "^_^"
        self.placeholderLabel.textColor = UIColor.HexColor(0x9B9B9B)
        
        self.leftRightDistance = 15.0
        self.middleDistance = 5.0
        self.buttonMinWidth = 60
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
