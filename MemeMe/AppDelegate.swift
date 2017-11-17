//
//  AppDelegate.swift
//  MemeMe
//
//  Created by dmikhov on 25.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes: [Meme] = [
        Meme("top1", "bot1", nil, nil),
        Meme("top2", "bot2", nil, nil),
        Meme("top3", "bot3", nil, nil),
        Meme("top4", "bot4", nil, nil),
        Meme("top5", "bot5", nil, nil),
        Meme("top6", "bot6", nil, nil)
    ]


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("app")
        return true
    }

}

