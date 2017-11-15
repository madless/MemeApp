//
//  Meme.swift
//  MemeMe
//
//  Created by dmikhov on 14.11.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String
    var botText: String
    var originImage: UIImage
    var memedimage: UIImage
    
    init(_ topText: String, _ botText: String, _ originImage: UIImage, _ memedimage: UIImage) {
        self.topText = topText
        self.botText = botText
        self.originImage = originImage
        self.memedimage = memedimage
    }
}
