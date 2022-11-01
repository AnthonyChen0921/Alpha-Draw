//
//  OptionModalViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/30/22.
//

import UIKit
import Hero
import ImageIO
import Firebase
import FirebaseStorage
import FirebaseDatabase


class LoadingViewController: UIViewController {
    var stableDiffusionInput: StableDiffusionInput?
    var token: String = ""
    var currentRunningId: String = ""
    var status = ""
    var stableDiffusionInitialData: StableDiffusionData?
    var stableDiffusionData: StableDiffusionData?
    var flag = false
    var cancelUrl: String = ""
    var loadingViewAdded = false

    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        addShadowToButton(button: cancelButton)
        addGifLoadingImages()

        getTokenFromUser(completion: { token in
            self.token = token
            self.loadStableDiffusionRequest()
        })
        // register a timer to call refreshStableDiffusionResult every 1 second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshStableDiffusionResult), userInfo: nil, repeats: true)
        // register a timer to call checkStatus every 1 second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
    }

    // get token from user and provide a escaping closure for token string
    func getTokenFromUser(completion: @escaping (String) -> Void) {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        // get user data from firebase
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user_id!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                // print("Document data: \(dataDescription)")
                let token = document.get("token") as! String
                self.token = token
                completion(token)
            } else {
                print("Document does not exist")
            }
        }
    }
    

    

    func loadStableDiffusionRequest() {
        // load stableDiffusionInput into the request
        var request = StableDiffusionBodyReuqest()
        request.version = "c24bbf13332c755f9e1c8b3f10c7f438889145def57d554a74ea751dc5e3b509"
        request.input = stableDiffusionInput!

        // call fetchStableDiffusionInitialRequest to get the initial request data
        fetchStableDiffusionInitialRequest(completion: { stableDiffusionData in
            // print(stableDiffusionData)
            self.currentRunningId = stableDiffusionData.id!
            self.cancelUrl = stableDiffusionData.urls!.cancel!
            self.stableDiffusionInitialData = stableDiffusionData
        }
        , bodyRequest: request, token: token)
    }

    @objc func refreshStableDiffusionResult(){
        fetchStableDiffusionByPredictionId(completion: { stableDiffusionData in
            //print(stableDiffusionData)
            if (stableDiffusionData.status == "succeeded") {
                self.stableDiffusionData = stableDiffusionData
                self.status = "succeeded"
            }
            else if(stableDiffusionData.status == "failed") {
                self.stableDiffusionData = stableDiffusionData
                self.status = "failed"
                print(self.stableDiffusionData?.error!)
            }
            else{
                print("current status is \(stableDiffusionData.status ?? "Starting")")
            }
        }, predictionId: currentRunningId, token: token)
    }

    @objc func checkStatus(){
        if (!flag && status == "succeeded") {
            removeGiftLoadingImages()
            pushToNextVC()
            flag = true
        }
        else if (!flag && status == "failed") {
            // add an alert to notify user that the request failed, click ok to go back
            let alert = UIAlertController(title: "Request Failed: NSFW content detected", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
            flag = true
        }
    }

    func pushToNextVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let outputT2IViewController = storyboard.instantiateViewController(identifier: "outputT2IPage") as! OutputT2IViewController
        outputT2IViewController.stableDiffusionData = self.stableDiffusionData
        self.navigationController?.pushViewController(outputT2IViewController, animated: true)
    }

    func addGifLoadingImages(){
        // add a gif view to the view, and set the gif to loop forever, 
        // and set the gif to play automatically when the view loads
        if(!loadingViewAdded){
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
            loadingViewAdded = true
        }
    }
    func removeGiftLoadingImages(){
        for subview in self.view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        // alert user to confirm cancel
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // if cancel url is "", then tell user to do again
            if (self.cancelUrl == "") {
                let alert = UIAlertController(title: "Cancel", message: "Cancel failed, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else { 
                // cancel the request using the cancel url and token
                cancelStableDiffusionRequest(cancelUrl: self.cancelUrl, token: self.token)
                // remove gif
                self.removeGiftLoadingImages()
                // pop to previous view controller
                self.navigationController?.popViewController(animated: true)
            }
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
    

    // MARK: - BACKUP CODE

    // func getTokenFromUser(){
    //     // get user data by user_id from UserDefaults
    //     let user_id = UserDefaults.standard.string(forKey: "user_id")

    //     // get user data from firebase
    //     let db = Firestore.firestore()
    //     db.collection("users").document(user_id!).getDocument { (document, error) in
    //         if error != nil {
    //             // show alert
    //             let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
    //             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //             alert.overrideUserInterfaceStyle = .dark
    //             self.present(alert, animated: true)
    //         } else {
    //             if document != nil && document!.exists {
    //                 // get token from user data
    //                 self.token = document!.get("token") as! String
    //             }
    //         }
    //     }
    // }


}
