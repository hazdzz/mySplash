//
//  ScrollViewDelegate.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import UIKit

extension PhotoViewController: UIScrollViewDelegate {
    
    func toggleZoom(location: CGPoint) {
        
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let aspectRatio = view.frame.height / view.frame.width // (1.78)
            let imageSize = imageView.image!.size
            
            var viewSize: CGSize
            if imageSize.width > imageSize.height {
                viewSize = CGSize(width: imageSize.height / aspectRatio, height: imageSize.height)
            } else {
                viewSize = CGSize(width: imageSize.width, height: imageSize.width / aspectRatio)
            }
            
            let centerX = location.x - viewSize.width / 2
            let centerY = location.y - viewSize.height / 2
            
            scrollView.zoom(to: CGRect(x: centerX, y: centerY, width: viewSize.width, height: viewSize.height), animated: true)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateMinZoomScale(for size: CGSize) {
        guard isImageLoaded == true else { return }
        guard let imageWidth = imageView.image?.size.width,
            let imageHeight = imageView.image?.size.height else { return }
        
        let widthScale = size.width / imageWidth
        let heightScale = size.height / imageHeight
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(for: view.bounds.size)
    }
    
    func updateConstraints(for size: CGSize) {
        guard isImageLoaded == true else { return }
        
        let displayWidth = imageView.layer.frame.width
        let displayHeight = imageView.layer.frame.height
        
        let xOffset = max(0, (size.width - displayWidth) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        let yOffset = max(0, (size.height - displayHeight) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        view.layoutIfNeeded()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(for: view.bounds.size)
    }
    
}
