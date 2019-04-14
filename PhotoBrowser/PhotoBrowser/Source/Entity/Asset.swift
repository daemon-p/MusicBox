//
//  Asset.swift
//  PhotoBrowser
//
//  Created by What on 2019/4/14.
//  Copyright © 2019 dumbass. All rights reserved.
//

import Photos


enum Album {
    case all(PHFetchResult<PHAsset>)
    case album(PHFetchResult<PHAssetCollection>)
    case userCollection(PHFetchResult<PHCollection>)
}
