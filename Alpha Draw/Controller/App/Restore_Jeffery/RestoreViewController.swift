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
    var SuperResolutionData: SuperResolutionData?
    var current_imageUrl2: String = ""
    var outputImage: UIImage?
    var status = ""
    //var flag = false
    
    @IBOutlet weak var upLoadImage: UIImageView!
    
    @IBOutlet weak var resultImage: UIImageView!
    
    let db = Firebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTokenFromUser()
        addShadowToImage(image : upLoadImage)
        addShadowToImage(image: resultImage)
        // upLoadImage.image = getFixingPicture()
        // let the image be clickable and give the tap
        upLoadImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        upLoadImage.addGestureRecognizer(tapGesture)
        //print the current user using the get current user function
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshStableDiffusionResult), userInfo: nil, repeats: true)
        // register a timer to call checkStatus every 1 second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
    }

    //fuction to add shadow to the image using the image view
    func addShadowToImage(image: UIImageView) {
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 0, height: 0)
        image.layer.shadowRadius = 15
        image.layer.shadowOpacity = 0.4
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        //image.layer.masksToBounds = false

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
                //loadSuperResRequest()
                //set the result image to be the loading image
                resultImage.image = UIImage(named: "loadingxtx")
            }
            
            
        }
        
    }

    func loadSuperResRequest() {
        // load stableDiffusionInput into the request
        var request = SuperResolutionReuqest()
        let superRes = srConfig.superRes(image_url: current_imageUrl)
        print(superRes)
        request.version = "660d922d33153019e8c263a3bba265de882e7f4f70396546b6c9c8f9d47a021a"
        //request.version = "9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3"
        request.input = superRes
        getTokenFromUser()

        // call fetchStableDiffusionInitialRequest to get the initial request data
        fetchSuperResImage(completion: { SuperResolutionData in
            print("141421341241241421412412341")
            print(SuperResolutionData)
            self.currentRunId = SuperResolutionData.id!
            self.cancelUrl = SuperResolutionData.urls!.cancel!
            self.superResolutionInitialData = SuperResolutionData
            //self.setImageOfSuperResData(SuperResolutionData: SuperResolutionData)
            //get the image url from the output
            //self.current_imageUrl2 = SuperResolutionData.output![0]
        }, bodyRequest: request, token: token)
        //check if the request is done if not then call the function again
    }

    
    func setImageOfSuperResData(SuperResolutionData: SuperResolutionData) {
        // // get stableDiffusionData image url
        // let imageUrl = SuperResolutionData.output!
        // outputImage = getImageFromUrl(url: imageUrl)
        // //set the resultImage to outputImage
        // //print the imageURL
        // print("123123123123" + imageUrl)
        // resultImage.image = outputImage
        //use multiple thread to get the image url
        DispatchQueue.global(qos: .userInitiated).async {
            // get stableDiffusionData image url
            let imageUrl = SuperResolutionData.output!
            self.outputImage = getImageFromUrl(url: imageUrl)
            //set the resultImage to outputImage
            DispatchQueue.main.async {
                self.resultImage.image = self.outputImage
            }
        }
    }
    
    func uploadToFireStore() {
        // get user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        // uploadImageToStorage(image: UIImage, id: String, userid: String? = "Admin", imageType: String? = "Image",completion: @escaping (String) -> Void)
        db.uploadImageToStorage(image: outputImage!, id: "result", userid: user_id, imageType: "SuperRes", completion: { url in
            // uploadImageToFireStore(imageUrl: String, id: String, userid: String? = "Admin", imageType: String? = "Image", completion: @escaping (String) -> Void)
            // do nothing
        })
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        // UIImageWriteToSavedPhotosAlbum(outputImage!, nil, nil, nil)
        // show an alert to tell the user that the image has been saved
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved to your cloud.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.uploadToFireStore()
        }))
        self.present(alert, animated: true)
    }
    
    
    
    @objc func refreshStableDiffusionResult(){
        fetchsuperResByPredictionId(completion: { SuperResolutionData in
            if (SuperResolutionData.status == "succeeded") {
                self.SuperResolutionData = SuperResolutionData
                self.status = "succeeded"
            }
            else if(SuperResolutionData.status == "failed") {
                self.SuperResolutionData = SuperResolutionData
                self.status = "failed"
                //self.errorMessage = SuperResolutionData.error!
            }
            else if(SuperResolutionData.status == "processing") {
                self.SuperResolutionData = SuperResolutionData
                self.status = "processing"
            }
        }, predictionId: currentRunId, token: token)
    }
    
    
    @objc func checkStatus(){
        if (status == "succeeded") {
            //print(SuperResolutionData)
            setImageOfSuperResData(SuperResolutionData: SuperResolutionData!)
            //flag = true
        }
        else if (status == "failed") {
            // add an alert to notify user that the request failed, click ok to go back
            print("fuxk it failed")
            //flag = true
        }
    }
    
    
    
    
    


}
