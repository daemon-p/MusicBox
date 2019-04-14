//
//  ViewController.swift
//  Host
//
//  Created by What on 2018/12/4.
//  Copyright © 2018 dumbass. All rights reserved.
//

import MusicBox
import PhotoBrowser

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        try! Assistent.audioPlayer.set(resource: .file("Toca Toca", "mp3", .main))
    }
}

class CompressViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(PhotoBrowser.entrance, animated: true)
    }
}
