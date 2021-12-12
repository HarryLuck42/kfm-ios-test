//
//  ViewBackgroundRounded.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import Foundation
import UIKit

class ViewBackgroundRounded: UIControl {
    
    private var consRadius : Int = 28
    private var corners: UIRectCorner = [.topLeft,.topRight]
    
    override func awakeFromNib() {
        super.awakeFromNib()
//         self.setFrameSizeUIScreen() // First, Set size view
         self.setCornerRadiusBackground()
        
    }
    

    
    public func setCornerRadiusBackground(){
        self.roundedCorners(corners: corners, radius: CGFloat(consRadius))
    }
    
}
