//
//  ViewController.swift
//  Host
//
//  Created by What on 2018/12/4.
//  Copyright © 2018 dumbass. All rights reserved.
//

import MusicBox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        try! Assistent.audioPlayer.set(resource: .file("Toca Toca", "mp3", .main))
    }
}


class SecViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
