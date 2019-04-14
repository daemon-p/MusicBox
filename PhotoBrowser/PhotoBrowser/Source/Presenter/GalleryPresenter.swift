//
//  GalleryPresenter.swift
//  PhotoBrowser
//
//  Created by What on 2019/4/14.
//  Copyright © 2019 dumbass. All rights reserved.
//

import UIKit

protocol GalleryPresenterInput: class {
    var output: GalleryPresenterOutput? { set get }
    func loadItems()
    func selectItem(at indexPath: IndexPath)
}

protocol GalleryPresenterOutput: class {
    func updated(_ albums: [Album])
}

class GalleryPresenter: GalleryPresenterInput {

    let input: GalleryInteractorInput
    weak var output: GalleryPresenterOutput?
    let router: RouterProviding
    init(input: GalleryInteractorInput = GalleryInteractor(), output: GalleryPresenterOutput, router: RouterProviding = RouterProvider()) {
       self.router = router
        self.output = output
        self.input = input
        input.output = self
    }
    
    func selectItem(at indexPath: IndexPath) {
        router.show()
    }
    
    func loadItems() {
        input.loadIterms()
    }
}

extension GalleryPresenter: GalleryInteractorOutput {
    func updated(_ albums: [Album]) {
        output?.updated(albums)
    }
}
