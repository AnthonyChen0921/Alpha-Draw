//
//  SingleImageViewController.swift
//  Alpha Draw
//
//  Created by Leonardo Nan on 2022/12/3.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet var Screen: UIView!
    var ImageSave: UIImage!

    @IBOutlet weak var ImageShow: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Show image")
        if let image = ImageSave {
            ImageShow.image = image
        }
        // Do any additional setup after loading the view.

        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerRight.direction = .right
        
        Screen.addGestureRecognizer(swipeGestureRecognizerRight)
    }
    
    @objc private func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("swipe to right")
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadData(image: UIImage) {
        print("singleImageViewController load data")
        ImageSave = image
    }

}
