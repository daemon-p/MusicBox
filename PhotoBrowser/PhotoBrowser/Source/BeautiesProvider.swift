//
//  BeautiesProvider.swift
//  PhotoBrowser
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

import Standard

struct BeautiesEngine {
    
    static let `default`: BeautiesEngine = .init()
    
    func fetch() -> [UIImage] {
        
        let queue: DispatchQueue = .init(label: "com.dumbass.loadBeauties")

        func image(for order: Int) -> UIImage {
            let path = Bundle.current.path(forResource: String(format: "%03d", order), ofType: "jpeg")!
            return UIImage(contentsOfFile: path)!
        }
        
        return queue.sync {
            (0..<105).map(image(for:))
        }
    }
}
