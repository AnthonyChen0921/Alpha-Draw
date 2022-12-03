//
//  RestoreViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore


class RestoreViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var hasToken: Bool = true
    var token: String = ""
    var current_imageUrl: String = ""
    var currentRunId: String = ""
    var cancelUrl: String = ""
    var superResolutionInitialData: SuperResolutionData?
    
    @IBOutlet weak var upLoadImage: UIImageView!
    let db = Firebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToImage(image : upLoadImage)
        // upLoadImage.image = getFixingPicture()
        // let the image be clickable and give the tap
        upLoadImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        upLoadImage.addGestureRecognizer(tapGesture)
        //print the current user using the get current user function
        print("123412412412412341241241241241")
        print(getCurrentUser())
    }

    //fuction to add shadow to the image using the image view
    func addShadowToImage(image: UIImageView) {
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 0, height: 0)
        image.layer.shadowRadius = 15
        image.layer.shadowOpacity = 0.8
        image.layer.masksToBounds = false

    }

    //function to open the image picker when the image is tapped
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }

    //function to show the selected image in the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            upLoadImage.image = image
            db.uploadImageToStorage(image: image, id: "upload", userid:getCurrentUser(), imageType: "upload", completion: { (url) in
                self.current_imageUrl = url
                print("current_imageUrl is \(self.current_imageUrl)")
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }

    //function get the current user info from firebase
    func getCurrentUser() -> String {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid
        }
        return ""
    }
    
    func checkTokenFromUser() {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user_id!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let token = document.data()!["token"] as! String
                // if token is null
                if token == "null" {
                    self.hasToken = false
                }
            } else {
                self.hasToken = false
            }
        }
    }

    func getTokenFromUser() {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user_id!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let token = document.data()!["token"] as! String
                self.token = token
            }
        }
    }
    
    var srConfig: HighResConfig = HighResConfig(width: 512, height: 768, prompt_strength: 0.8, num_inference_steps: 50, guidance_scale: 7.5)
    
    @IBAction func createButtonClicked(_ sender: Any) {
        if(!hasToken){
            // show alert to tell user to add token
            let alert = UIAlertController(title: "Token Setup Required", message: "Please setup your token first to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        } else{
            if( current_imageUrl == ""){
                let alert = UIAlertController(title: "No Image Selected", message: "Please select an image to restore.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } 
            else{
                loadSuperResRequest()
            }
            
            
        }
        
    }

    func loadSuperResRequest() {
        // load stableDiffusionInput into the request
        var request = SuperResolutionReuqest()
        var superRes = srConfig.superRes(image_url: current_imageUrl)
        print(superRes)
        request.version = "660d922d33153019e8c263a3bba265de882e7f4f70396546b6c9c8f9d47a021a"
        request.input = superRes
        getTokenFromUser()

        // call fetchStableDiffusionInitialRequest to get the initial request data
        fetchSuperResImage(completion: { SuperResolutionData in
            self.currentRunId = SuperResolutionData.id!
            self.cancelUrl = SuperResolutionData.urls!.cancel!
            self.superResolutionInitialData = SuperResolutionData
        }, bodyRequest: request, token: token)
        
    }
    
    
    
    
    


}
