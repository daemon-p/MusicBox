//
//  BrowserEntity.swift
//  PhotoBrowser
//
//  Created by What on 2019/2/3.
//  Copyright © 2019 dumbass. All rights reserved.
//

struct Beauty {
    
    let id: String
    let path: String
    
    var image: UIImage? {
        return UIImage(contentsOfFile: path)
    }
}
