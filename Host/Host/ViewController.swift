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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        imageView.kf.setImage(with: _DataPrvider.init(url: URL(fileURLWithPath: "/Users/Dumbass/Desktop/d209ed59b47d159f2f6703e41113c0cd.gif")), options: [.forceRefresh])
//        let image = UIImage.animatedImageNamed("", duration: "T##TimeInterval")

    }
}
