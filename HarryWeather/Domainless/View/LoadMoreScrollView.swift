//
//  LoadMoreScrollView.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 11/11/21.
//

import UIKit
import SkeletonView
import SnapKit

fileprivate struct LoadMoreScrollViewKeys {
    static var View = "LoadMoreScrollViewKeys_View"
    static var Block = "LoadMoreScrollViewKeys_Block"
}

fileprivate struct LoadMoreScrollViewConstants {
    static let indicatorToLabelMargin: CGFloat = 10
    static let loadMoreViewHeight: CGFloat = 36
}

typealias LoadMoreLoadingBlock = (() -> ())

extension UIScrollView: UIScrollViewDelegate {
    private var loadMoreView: UIView? {
        get {
            guard let view = objc_getAssociatedObject(self, &LoadMoreScrollViewKeys.View) as? UIView else {
                let newView = generateView()
                objc_setAssociatedObject(self, &LoadMoreScrollViewKeys.View, newView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return newView
            }
            
            return view
        }
        set {
            objc_setAssociatedObject(self, &LoadMoreScrollViewKeys.View, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loadMoreLoadingBlock: LoadMoreLoadingBlock? {
        get {
            guard let block = objc_getAssociatedObject(self, &LoadMoreScrollViewKeys.Block) as? LoadMoreLoadingBlock else {
                return nil
            }
            
            return block
        }
        set {
            objc_setAssociatedObject(self, &LoadMoreScrollViewKeys.Block, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func generateView() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = false
        indicator.tag = 1
        container.addSubview(indicator)
        
        let label = UILabel()
        label.text = "Load More..."
        label.tag = 2
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        container.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0.5 * (indicator.frame.size.width + LoadMoreScrollViewConstants.indicatorToLabelMargin))
            make.centerY.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalTo(label.snp.leading).offset(-LoadMoreScrollViewConstants.indicatorToLabelMargin)
        }
        
        return container
    }
    
    private func loadMoreYPosition() -> CGFloat {
        let myHeight = frame.size.height
        let myContentHeight = contentSize.height
        
        return max(myHeight, myContentHeight)
    }
    
    func enableLoadMore(enable: Bool) {
        if enable {
            if let theView = loadMoreView {
                theView.removeFromSuperview()
                addSubview(theView)
              
              theView.frame = CGRect(x: 0, y: loadMoreYPosition(), width: frame.size.width, height: LoadMoreScrollViewConstants.loadMoreViewHeight)
            }
        } else {
            stopLoading()
            
            if let theView = loadMoreView, theView.superview != nil {
                theView.removeFromSuperview()
            }
        }
    }
    
    private func startLoading() {
        if let indicator = viewWithTag(1) as? UIActivityIndicatorView {
            indicator.startAnimating()
        }
        if let label = viewWithTag(2) as? UILabel {
            label.text = "Loading..."
        }
        
        let gap = self.frame.size.height - self.contentSize.height
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: LoadMoreScrollViewConstants.loadMoreViewHeight + max(gap, 0), right: 0)
        
        if let block = loadMoreLoadingBlock {
            block()
        }
    }
    
    func stopLoading() {
        if let indicator = viewWithTag(1) as? UIActivityIndicatorView {
            indicator.stopAnimating()
        }
        if let label = viewWithTag(2) as? UILabel {
            label.text = "Load More..."
        }
        
        if let theView = loadMoreView, theView.superview != nil {
          theView.frame = CGRect(x: 0, y: loadMoreYPosition(), width: frame.size.width, height: LoadMoreScrollViewConstants.loadMoreViewHeight)
        }
        
        contentInset = UIEdgeInsets.zero
    }
    
    private func isLoading() -> Bool {
        if let indicator = viewWithTag(1) as? UIActivityIndicatorView {
            return indicator.isAnimating
        }
        
        return false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if loadMoreView?.superview == nil { return }
        let gap = max(self.contentSize.height, self.frame.size.height) - self.frame.size.height
        
        if scrollView.contentOffset.y >= (gap + LoadMoreScrollViewConstants.loadMoreViewHeight) && !isLoading() {
            startLoading()
        }
        
        if let theView = loadMoreView, theView.superview != nil {
            if theView.frame.origin.y >= contentSize.height {
                return
            }
            
            theView.frame = CGRect(x: 0, y: loadMoreYPosition(), width: frame.size.width, height: LoadMoreScrollViewConstants.loadMoreViewHeight)
        }
    }
}
