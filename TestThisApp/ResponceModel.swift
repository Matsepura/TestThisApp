//
//  ResponceModel.swift
//  TestThisApp
//
//  Created by Semen Matsepura on 20.01.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import Foundation

class ResponceModel {
    
    var images: Array<String>
    var id: Int
    var name: String
    var url: String
    var time: Int
    
    init(image: Array<String>, id: Int, name: String, url: String, time: Int) {
        
        self.images = image
        self.id = id
        self.name = name
        self.url = url
        self.time = time
    }
}
