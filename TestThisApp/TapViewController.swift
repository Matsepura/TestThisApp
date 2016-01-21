//
//  TapViewController.swift
//  TestThisApp
//
//  Created by Semen Matsepura on 20.01.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TapViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Property
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    let test = CustomCollectionViewCell()
    var responceFromSegue = [ResponceModel]()
    var headerImageView = CollectionReusableView()
    
    var headerView: UIView!
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        headerView = headerImageView
        
        myCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        myCollectionView.contentOffset = CGPoint(x: 0, y: 0)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerImageView.frame.origin.y, width: myCollectionView.bounds.width, height: headerImageView.frame.height)
        if myCollectionView.contentOffset.y <= -headerImageView.frame.height {
            headerRect.origin.y = myCollectionView.contentOffset.y
            headerRect.size.height = -myCollectionView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scroll")
        updateHeaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responceFromSegue[0].images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.picCollectionView.af_setImageWithURL(NSURL(string:responceFromSegue[0].images[indexPath.row])!, placeholderImage: UIImage(named: "pic"))
        cell.picCollectionView.layer.borderWidth = 0
        cell.picCollectionView.layer.masksToBounds = false
        cell.picCollectionView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.picCollectionView.layer.cornerRadius = cell.picCollectionView.frame.size.width/2
        cell.picCollectionView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! CollectionReusableView
        
        headerView.image.af_setImageWithURL(NSURL(string:responceFromSegue[0].url)!, placeholderImage: UIImage(named: "pic"))
        
        return headerView
    }
}
