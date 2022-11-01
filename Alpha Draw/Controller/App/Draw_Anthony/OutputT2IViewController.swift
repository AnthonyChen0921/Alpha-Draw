//
//  OutputT2IViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit

class OutputT2IViewController: UIViewController {
    var outputImageUrl: String?
    var outputImage: UIImage?
    var stableDiffusionData: StableDiffusionData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // get stableDiffusionData image url
        let imageUrl = stableDiffusionData?.output![0]
        outputImage = getImageFromUrl(url: imageUrl!)

        // add an image view to the view
        let imageView = UIImageView(image: outputImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
        

    }
    

}
