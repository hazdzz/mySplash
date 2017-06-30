//
//  PhotoStreamCollectionViewController.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//
import UIKit
import Kingfisher

private let reuseIdentifier = "CollectionViewCell"
let ItemsPerload = 30

class CollectionViewController: UICollectionViewController, DataManagerDeledate {
    
    var photos = [PhotoModel]()
    var lastPageLoaded = 1
    var clearCacheLabel: UILabel?
    
    let dataManager = DataManger()
    let kf = KingfisherManager()
    
    public class KingfisherManager: NSObject {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        dataManager.deledate = self
        dataManager.getData(forPage: lastPageLoaded)
        lastPageLoaded += 1
        
        let creditsView = CreditsView(width: view.frame.width, bottomOffset: -30)
        collectionView?.addSubview(creditsView)
        
        clearCacheLabel = UILabel(frame: CGRect(x: 0, y: -164, width: view.frame.width, height: 20))
        clearCacheLabel!.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: UIFontWeightMedium)
        clearCacheLabel?.textColor = .red
        clearCacheLabel?.alpha = 0.2
        clearCacheLabel?.textAlignment = .center
        clearCacheLabel?.text = "Pull Down to Clear Cache"
        
        collectionView?.addSubview(clearCacheLabel!)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -195 {
            clearCacheLabel?.alpha = 1
            clearCacheLabel?.text = "Release to Clear Cache"
        } else {
            clearCacheLabel?.alpha = 0.2
            clearCacheLabel?.text = "Pull Down to Clear Cache"
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < -195 {
            /*kf.cache.clearDiskCache({ Void in
                print("disk cleared")
                self.screenFlash()
            })*/
        }
    }
    
    func screenFlash() {
        let flashView = UIView(frame: view.frame)
        flashView.backgroundColor = .white
        flashView.alpha = 0
        
        view.insertSubview(flashView, aboveSubview: collectionView!)
        
        UIView.animate(withDuration: 0.2, animations: {
            flashView.alpha = 1
        }, completion: { Bool in
            UIView.animate(withDuration: 0.2, animations: {
                flashView.alpha = 0
            }, completion: { Bool in
                flashView.removeFromSuperview()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pushPhotoModels(_ photoModels: [PhotoModel]) {
        photos.append(contentsOf: photoModels)
        collectionView?.reloadData()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhotoSegue" {
            
            let selectedRow = collectionView?.indexPathsForSelectedItems?.first?.row
            let photo = photos[selectedRow!]
            
            let destination = segue.destination as! PhotoViewController
            destination.imageUrl = photo.rawUrl
            destination.name = photo.name
        }
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        // Configure the cell
        
        let photo = photos[indexPath.row]
        let urlString = photo.thumbnailUrl
        let url = NSURL(string: urlString!)
        
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url as! Resource?, placeholder: nil, options: [.transition(ImageTransition.fade(0.1))], progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        performSegue(withIdentifier: "ShowPhotoSegue", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row + 7 > photos.count {
            dataManager.getData(forPage: lastPageLoaded)
            lastPageLoaded += 1
        }
    }
    
    @IBAction func unwindFromPhoto(segue: UIStoryboardSegue) {
        
    }

}
