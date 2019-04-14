//
//  BrowserViewController.swift
//  Browser
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

import MBUIKit

public class BrowserNavigationController: UINavigationController {
}

class BrowserViewController: UICollectionViewController {
    
    var beauties: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beauties.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BrowserCell.self, for: indexPath)
        cell.set(image: UIImage(contentsOfFile: beauties[indexPath.item])!)
        return UICollectionViewCell()
    }
    
}
