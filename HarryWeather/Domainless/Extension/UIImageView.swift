//
//  UIImageView.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 11/11/21.
//
import Foundation
import Kingfisher
import SkeletonView

extension UIImageView{
    func round(){
      self.layer.masksToBounds = false
      self.layer.cornerRadius = self.frame.height/2
      self.clipsToBounds = true
    }
    
    /// Set image download with animation
    /// - Parameter url: Url type of URL
    /// - Parameter imgPlaceHolder: Image default
    func downloadWithTransition(image url: URL, imgPlaceHolder: String) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: imgPlaceHolder),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
    }
}
