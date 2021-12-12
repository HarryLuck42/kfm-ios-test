//
//  ViewShadow.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 11/11/21.
//

import UIKit

class ViewShadow: UIControl {
    
    var shadowRadius: CGFloat?{
        didSet{
            self.layer.shadowRadius = shadowRadius ?? 2.5
        }
    }
    
    var cornerRadius: CGFloat?{
        didSet{
            self.layer.cornerRadius = cornerRadius ?? 10
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius ?? 10
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius ?? 2.5
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}
