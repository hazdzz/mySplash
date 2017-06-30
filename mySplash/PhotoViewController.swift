//
//  PhotoViewController.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var likeButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    
    var imageUrl: String?
    var name: String?
    
    var zoomedInScale: CGFloat?
    
    var isImageLoaded = false
    
    var activityIndicator: UIActivityIndicatorView?
    
    var isNavigationBarHidden = false {
        didSet {
            if isNavigationBarHidden {
                navigationBar.isHidden = true
                view.backgroundColor = .black
                
                guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else { return }
                statusBar.alpha = 0
                
            } else {
                navigationBar.isHidden = false
                view.backgroundColor = .white
                
                guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else { return }
                statusBar.alpha = 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        activityIndicator?.color = .gray
        activityIndicator?.startAnimating()
        
        view.insertSubview(activityIndicator!, aboveSubview: scrollView)
        
        setGestureRecognizers()
    }

    func viewWillAppear(animated: Bool) {
        
        if let imageUrl = self.imageUrl {
           let url = NSURL(string: imageUrl)
            
            imageView.kf.setImage(with: url as! Resource?, placeholder: nil, options: [.transition(ImageTransition.fade(0.1))], progressBlock: nil, completionHandler: { Void in
                
                self.isImageLoaded = true
                self.activityIndicator?.stopAnimating()
                
                self.updateMinZoomScale(for: self.view.bounds.size)
                self.updateConstraints(for: self.view.bounds.size)
            })
        }
        if let name = self.name {
            navigationBarTitle.title = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setGestureRecognizers() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        
        scrollView.addGestureRecognizer(longPress)
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.addGestureRecognizer(singleTap)
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            saveImage()
        }
    }
    
    func handleDoubleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: imageView)
        toggleZoom(location: location)
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        isNavigationBarHidden = !isNavigationBarHidden
    }
    
    func saveImage() {
        if let image = imageView.image {
            let actionSheet = UIAlertController(title: "Save to Camera Roll", message: nil, preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "Save Image", style: .default, handler: { Void in
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(saveAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func likeButtonClick(sender: AnyObject) {
        self.saveImage()
    }

}
