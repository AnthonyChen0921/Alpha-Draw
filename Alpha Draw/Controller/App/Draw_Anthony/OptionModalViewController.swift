//
//  OptionModalViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/30/22.
//

import UIKit
import Hero
import ImageIO

class OptionModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // add a gif view to the view, and set the gif to loop forever, 
        // and set the gif to play automatically when the view loads
        let loadingGif = UIImage.gifImageWithName("loadingTeatres")
        let imageView = UIImageView(image: loadingGif)  
        // set the frame to full screen
        // imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.center = self.view.center
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.startAnimating()
        self.view.addSubview(imageView)
        addGloomyShadowEffectAnimation(imageView: imageView)

    }

    // add gloomy shadow effect to imageView
    func addGloomyShadowEffectAnimation(imageView: UIImageView) {
        // add shadow to the imageView
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.masksToBounds = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
