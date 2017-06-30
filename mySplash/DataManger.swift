//
//  DataManger.swift
//  mySplash
//
//  Created by Leo Zhang on 6/12/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import AFNetworking

protocol DataManagerDeledate {
    func pushPhotoModels(_ PhotoModels: [PhotoModel])
}

class DataManger {
    
    var deledate: DataManagerDeledate?
    
    let manager = AFHTTPSessionManager(baseURL: NSURL(string: "https://api.unsplash.com/") as URL?)
    
    init() {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func getData(forPage pageNumber: Int) {
        
        let clientId = "593a516795c70cc3d7628bd165815716c02be23b67b8b4a9c539dd30e30a9419" // Application ID
        
        manager.get("photos/?client_id=" + clientId,
                    parameters: [ "page": pageNumber, "per_page" : 30 ],
                    progress: nil,
                    success: { task, data in
                        
                        var photoModels = [PhotoModel]()
                        
                        if let photoData = data as? NSArray {
                            for photo in photoData {
                                let photo = photo as! Dictionary<String, AnyObject>
                        
                                if let thumbnail = photo["urls"]!["thumb"] as? String,
                                let rawUrl    = photo["urls"]!["raw"] as? String,
                                let name      = photo["user"]!["name"] as? String {
                                    
                                    let photo = PhotoModel(rawUrl: rawUrl, thumbnailUrl: thumbnail, name: name)
                                    photoModels.append(photo)
                                    
                                }
                            }
                        }
                        
                        self.deledate?.pushPhotoModels(photoModels)
                    },
                    failure: { task, error in
                        print(error)
                    }
        )
    }
    
}
