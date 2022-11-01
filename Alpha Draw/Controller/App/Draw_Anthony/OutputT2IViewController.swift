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
        imageView.frame = CGRect(x: 0, y: 0, width: 256, height: 384)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
        

    }
    @IBAction func discardButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        // UIImageWriteToSavedPhotosAlbum(outputImage!, nil, nil, nil)
        // show an alert to tell the user that the image has been saved
        let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)

    }
    

}
