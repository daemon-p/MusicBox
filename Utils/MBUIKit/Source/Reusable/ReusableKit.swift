//
//  ReusableKit.swift
//  MBUIKit
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

import UIKit

public protocol ReusableIdentifire: class {
    static var reuseIdentifier: String { get }
}

public extension ReusableIdentifire {
    static var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}

extension UICollectionViewCell: ReusableIdentifire {
}

public extension UICollectionView {
    
    func register<T: ReusableIdentifire>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UICollectionView {
    
    func dequeue<T>(_: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

