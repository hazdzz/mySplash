//
//  PhotoModel.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import UIKit

protocol PhotoModelDelegate {
    func thumbnailLoaded(for id: Int)
}

class PhotoModel {
    
    var rawUrl: String?
    var thumbnailUrl: String?
    var name: String?
    
    init(rawUrl: String, thumbnailUrl: String, name: String) {
        self.rawUrl = rawUrl
        self.thumbnailUrl = thumbnailUrl
        self.name = name
    }
    
}
