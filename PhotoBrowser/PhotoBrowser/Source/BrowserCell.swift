//
//  BrowserCell.swift
//  Browser
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

import UIKit.UICollectionViewController

class BrowserCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func set(image: UIImage) {
        imageView.image = image
    }
}
