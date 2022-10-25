//
//  Image.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit

class Image {
    var UIImage: UIImage?
    var url: String?
    var id: String?
    var name: String?
    

    init(UIImage: UIImage, url: String, id: String, name: String) {
        self.UIImage = UIImage
        self.url = url
        self.id = id
        self.name = name
    }


}
