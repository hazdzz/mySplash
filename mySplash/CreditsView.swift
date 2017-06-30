//
//  CreditsView.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import UIKit

class CreditsView: UIView {
    
    init(width: CGFloat, bottomOffset: CGFloat) {
        
        let viewHeight: CGFloat = 110
        
        super.init(frame: CGRect(x: 0, y: bottomOffset - viewHeight, width: width, height: viewHeight))
        
        let splashLogo = UIImageView(image: UIImage(named: "splash-icon180"))
        let logoSize = width / 4
        splashLogo.frame = CGRect(x: width / 2 - logoSize / 2, y: 0, width: logoSize, height: logoSize)
        
        let labelMark = UILabel(frame: CGRect(x: 0, y: logoSize, width: width, height: 20) )
        labelMark.textAlignment = .center
        labelMark.text = "Made by Matthew Tso"
        labelMark.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFontWeightRegular)
        
        let urlLabel = UILabel(frame: CGRect(x: 0, y: logoSize + labelMark.frame.height * 0.7, width: width, height: 20))
        urlLabel.textAlignment = .center
        urlLabel.text = "matthewtso.com"
        urlLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFontWeightRegular)
        
        self.addSubview(splashLogo)
        self.addSubview(labelMark)
        self.addSubview(urlLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
