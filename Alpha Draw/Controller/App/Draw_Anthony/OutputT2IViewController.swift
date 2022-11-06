//
//  OutputT2IViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class OutputT2IViewController: UIViewController {
    var outputImage: UIImage?
    var stableDiffusionData: StableDiffusionData?
    var width: Int = 256
    var height: Int = 384
    var id = ""
    let db = Firebase()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)

        // get width and height from getWidthAndHeightOfstableDiffusionData
        width = getWidthOfstableDiffusionData(stableDiffusionData: stableDiffusionData!) / 3 * 2
        height = getHeightOfstableDiffusionData(stableDiffusionData: stableDiffusionData!) / 3 * 2
        id = getIdOfstableDiffusionData(stableDiffusionData: stableDiffusionData!)

        // get prompt name from getInputNameOfstableDiffusionData
        let promptName = getInputNameOfstableDiffusionData(stableDiffusionData: stableDiffusionData!)

        // set output image from getOutputImageOfstableDiffusionData
        setImageOfstableDiffusionData(stableDiffusionData: stableDiffusionData!)

        // addImageViewToView
        addImageView()

        // addPromptNameToView
        addPromptNameToView(promptName: promptName)
        
        

    }
    @IBAction func discardButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        // UIImageWriteToSavedPhotosAlbum(outputImage!, nil, nil, nil)
        // show an alert to tell the user that the image has been saved
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved to your cloud.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // change this to nav to tab bar controllers
            // self.navigationController?.popToRootViewController(animated: true)
            self.uploadToFireStore()
        }))
        self.present(alert, animated: true)


    }

    func getWidthOfstableDiffusionData(stableDiffusionData: StableDiffusionData) -> Int {
        let width = stableDiffusionData.input?.width
        return Int(width!)!
    }

    func getHeightOfstableDiffusionData(stableDiffusionData: StableDiffusionData) -> Int {
        let height = stableDiffusionData.input?.height
        return Int(height!)!
    }

    func getIdOfstableDiffusionData(stableDiffusionData: StableDiffusionData) -> String {
        let id = stableDiffusionData.id
        return id!
    }
    
    func getInputNameOfstableDiffusionData(stableDiffusionData: StableDiffusionData) -> String {
        let inputName = stableDiffusionData.input?.prompt
        return inputName!
    }

    func setImageOfstableDiffusionData(stableDiffusionData: StableDiffusionData) {
        // get stableDiffusionData image url
        let imageUrl = stableDiffusionData.output![0]
        outputImage = getImageFromUrl(url: imageUrl)
    }

    func addImageView(){
        // add an image view to the view
        let imageView = UIImageView(image: outputImage)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // add shadow to the image
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.5
        view.addSubview(imageView)
    }


    func addPromptNameToView(promptName: String) {
        // add a label to the view
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.center = CGPoint(x: view.center.x, y: view.center.y - 400)
        label.textAlignment = .center
        label.text = promptName
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.black
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.5


        view.addSubview(label)
    }

    func uploadToFireStore() {
        // get user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        // uploadImageToStorage(image: UIImage, id: String, userid: String? = "Admin", imageType: String? = "Image",completion: @escaping (String) -> Void)
        db.uploadImageToStorage(image: outputImage!, id: id, userid: user_id, imageType: "StableDiffusion", completion: { url in
            // uploadImageToFireStore(imageUrl: String, id: String, userid: String? = "Admin", imageType: String? = "Image", completion: @escaping (String) -> Void)
            // do nothing
        })
    }

}
