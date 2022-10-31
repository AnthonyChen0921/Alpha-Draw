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

    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        addShadowToButton(button: cancelButton)

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
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        // alert user to confirm cancel
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.overrideUserInterfaceStyle = .dark

        self.present(alert, animated: true)
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
    


}
