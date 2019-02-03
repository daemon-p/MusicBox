//
//  Utils.swift
//  PhotoBrowser
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

import Foundation

private class _Bundle {}

extension Bundle {
    static var current: Bundle {
        return Bundle(for: _Bundle.self)
    }
}
