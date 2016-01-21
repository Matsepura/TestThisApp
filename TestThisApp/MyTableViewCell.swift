//
//  MyTableViewCell.swift
//  TestThisApp
//
//  Created by Semen Matsepura on 20.01.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    // MARK: - Property

    @IBOutlet weak var countPic: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var miniPicView: UIView!
    @IBOutlet weak var heightOfMiniPic: NSLayoutConstraint!

    var arrayPic = Array<String>()
    var lines:CGFloat = 0
    
    // MARK: - Create Pictures
    
    func createPictures(array: Array<String>) {
        
        miniPicView.backgroundColor = UIColor.whiteColor()
        for view in miniPicView.subviews {
            view.removeFromSuperview()
        }
        lines = 0
        var countPicInLine = 0
        var frameOfPic = CGRectMake(5, 5, 30, 30)
        var i = 0
        let lastOne = array.count
        
        frameOfPic = CGRectMake(5, 5, 30, 30)
        
        
        for pic in array {
            let imageView = UIImageView(frame: frameOfPic)
            let URL = NSURL(string: pic)!
            imageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "pic"))
            imageView.layer.borderWidth = 0
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.whiteColor().CGColor
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.clipsToBounds = true
            miniPicView.addSubview(imageView)
            i++
        
            if countPicInLine >= size && i != lastOne {
                frameOfPic.origin.y += 35
                frameOfPic.origin.x = 5
                
                lines++

                print("frameOfPic.origin.y += 35")
                print(miniPicView.frame.height)

                countPicInLine = 0
            } else {
                frameOfPic.origin.x += 35
                countPicInLine++
            }
        }
    }
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
