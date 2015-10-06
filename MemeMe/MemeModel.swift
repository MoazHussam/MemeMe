//
//  MemeModel.swift
//  MemeMe
//
//  Created by Moaz on 10/6/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    let bottomText: String
    let topText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    init(bottomText: String, topText: String, originalImage: UIImage, memedImage: UIImage) {
        
        self.bottomText = bottomText
        self.topText = topText
        self.memedImage = memedImage
        self.originalImage = originalImage
    }
}
