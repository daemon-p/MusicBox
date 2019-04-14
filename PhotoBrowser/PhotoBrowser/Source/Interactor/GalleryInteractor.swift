//
//  GalleryInteractor.swift
//  PhotoBrowser
//
//  Created by What on 2019/4/14.
//  Copyright © 2019 dumbass. All rights reserved.
//

protocol GalleryInteractorInput: class {
    func loadIterms()
    var output: GalleryInteractorOutput? { set get }
}

protocol GalleryInteractorOutput: class {
    func updated(_ albums: [Album])
}

extension GalleryInteractorOutput {
    func updated(_ albums: Album...) {
        updated(albums)
    }
}

class GalleryInteractor: GalleryInteractorInput {
    
    weak var output: GalleryInteractorOutput?
    private var engine: PhotoProviding
    private var albums: [Album]
    
    init(engine: PhotoProviding = PhotoEngine(), output: GalleryInteractorOutput? = nil) {
        self.albums = [.all(.init()), .album(.init()), .userCollection(.init())]
        self.engine = engine
        self.output = output
        self.engine.delegate = self
    }
    
    func loadIterms() {
        let allOptions = PHFetchOptions()
        allOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        albums[0] = .all(engine.loadAll(with: allOptions))
        albums[1] = .album(engine.loadAlbum(using: .smartAlbum, and: .albumRegular, with: nil))
        albums[2] = .userCollection(engine.loadUserCollection(with: nil))
        updateAlbumsIfNeeded()
    }
    
    private func updateAlbumsIfNeeded() {
        output?.updated(albums)
    }
}

extension GalleryInteractor: PhotoProviderDelegate {
    func assetUpdated(for asset: Album) {
        switch asset {
        case .all: albums[0] = asset
        case .album: albums[1]  = asset
        case .userCollection: albums[2] = asset
        }
        updateAlbumsIfNeeded()
    }
}
