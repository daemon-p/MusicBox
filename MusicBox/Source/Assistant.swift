//
//  Assistant.swift
//  MusicBox
//
//  Created by What on 2018/12/4.
//  Copyright © 2018 dumbass. All rights reserved.
//

import MBUIKit

let AssistiveControl: UIWindow = {
    let w: CGFloat = 48
    let window = UIWindow(frame: CGRect(x: 5, y: 200, width: w, height: w))
    window.rootViewController = AssistantViewController.loadInstance()
    window.makeKeyAndVisible()
    window.windowLevel = .init(rawValue: 1)
    return window
}()

public func AssistantSetup() {
    try? Assistent.audioPlayer.setup()
    _ = AssistiveControl
}

public enum Assistent {
    public static let audioPlayer: AudioPlayer = .init()
}

