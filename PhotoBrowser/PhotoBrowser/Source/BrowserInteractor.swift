//
//  BrowserInteractor.swift
//  Browser
//
//  Created by What on 2019/1/25.
//  Copyright © 2019 dumbass. All rights reserved.
//

protocol BrowserInteractorProtocol: AnyObject {
    func loadBeauties()
}

class BrowserInteractor {
    
    private let engine: BeautiesEngine
    private let presenter: BrowserPresenterProtocol
    
    init(engine: BeautiesEngine = .default, presenter: BrowserPresenterProtocol) {
        self.engine = engine
        self.presenter = presenter
    }
}

extension BrowserInteractor: BrowserInteractorProtocol {
    
    func loadBeauties() {
        
    }
}
