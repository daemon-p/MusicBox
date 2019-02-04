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
    
    func fetch() -> [Beauty] {
        
        let queue: DispatchQueue = .init(label: "com.dumbass.loadBeauties")

        func beauty(for order: Int) -> Beauty {
            return .init(
                id: UUID().uuidString,
                path: Bundle.current.path(forResource: String(format: "%03d", order), ofType: "jpeg")!
            )
        }
        
        return queue.sync {
            (0..<105).map(beauty(for:))
        }
    }
}
