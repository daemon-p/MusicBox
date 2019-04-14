//
//  PhotoEngine.swift
//  PhotoBrowser
//
//  Created by What on 2019/4/14.
//  Copyright © 2019 dumbass. All rights reserved.
//

@_exported import Photos

protocol PhotoProviding {
    var delegate: PhotoProviderDelegate? { set get }
    func loadAll(with options: PHFetchOptions?) -> PHFetchResult<PHAsset>
    func loadAlbum(using type: PHAssetCollectionType, and subType: PHAssetCollectionSubtype, with options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>
    func loadUserCollection(with options: PHFetchOptions?) -> PHFetchResult<PHCollection>
}

protocol PhotoProviderDelegate: AnyObject {
    func assetUpdated(for asset: Album)
}

class PhotoEngine: NSObject, PhotoProviding {
    
    weak var delegate: PhotoProviderDelegate?
    
    init(delegate: PhotoProviderDelegate? = nil) {
        self.delegate = delegate
    }
    
    func loadAll(with options: PHFetchOptions? = nil) -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: options)
    }
    
    func loadAlbum(using type: PHAssetCollectionType, and subType: PHAssetCollectionSubtype, with options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: type, subtype: subType, options: options)
    }

    func loadUserCollection(with options: PHFetchOptions?) -> PHFetchResult<PHCollection> {
        return PHCollection.fetchTopLevelUserCollections(with: options)
    }
}

extension PhotoEngine: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        changeInstance.changeDetails(for: PHFetchResult<PHAsset>()).flatMap {
            delegate?.assetUpdated(for: .all($0.fetchResultAfterChanges))
        }
        
        changeInstance.changeDetails(for: PHFetchResult<PHAssetCollection>()).flatMap {
            delegate?.assetUpdated(for: .album($0.fetchResultAfterChanges))
        }
        
        changeInstance.changeDetails(for: PHFetchResult<PHCollection>()).flatMap {
            delegate?.assetUpdated(for: .userCollection($0.fetchResultAfterChanges))
        }
    }
}
