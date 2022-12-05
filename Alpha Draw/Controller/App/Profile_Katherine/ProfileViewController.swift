//
//  ProfileViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var hyperLink: UITextView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tokenInbox: UITextField!
    @IBOutlet weak var pfpImageView: UIImageView!
    let metaData = StorageMetadata()
    let user_id = UserDefaults.standard.string(forKey: "user_id")
    var imageData:Data?
    var tokenData:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text! = getName()
        pfpImageView.image = getProfilePicture()
        pfpImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        pfpImageView.addGestureRecognizer(gesture)
    }
    @IBAction func createToken(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://replicate.com/account")! as URL)
    }
    
    
    @objc private func didTapChangeProfilePic(){
        print("change pic called")
        presentPhotoActionSheet()
    }
    @IBAction func submitToken(_ sender: Any) {
        tokenData = tokenInbox.text!
        do{
            guard tokenData != nil else{
                return
            }
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(user_id!)
            docRef.updateData(["token":tokenData!])
            let alert = UIAlertController(title: "Success", message: "You have successfully added token", preferredStyle: .alert)
            // when click on OK button, go to login page
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
            
            }
        
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        // logout user
        do {
            try Auth.auth().signOut()
            // clear user defaults
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "user_id")
            // go to welcome screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeViewController = storyboard.instantiateViewController(identifier: "WelcomeViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(welcomeViewController)
        } catch {
            // show alert
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        }
    }
    
    
    func getName() -> String {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        // get user data from firebase
        let db = Firestore.firestore()
        var name = ""
        db.collection("users").document(user_id!).getDocument { (document, error) in
            if error != nil {
                // show alert
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else {
                if document != nil && document!.exists {
                    // get name from user data
                    name = document!.get("name") as! String
                    self.username.text = name
                }
            }
        }
        return name
    }
    
    func getProfilePicture() -> UIImage {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        // get user data from firebase
        let db = Firestore.firestore()
        let pfp = UIImage()
        db.collection("users").document(user_id!).getDocument { (document, error) in
            if error != nil {
                // show alert
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else {
                if document != nil && document!.exists {
                    // get profile picture url
                    let pfp_url = document!.get("pfp") as! String
                    // get profile picture from url
                    let storageRef = Storage.storage().reference().child(pfp_url)
                    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        //check for errors
                        if error == nil && data != nil{
                            self.pfpImageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
        }
        return pfp
    }
    func uploadFile(){
        do{
            guard imageData != nil else{
                return
            }
            let path = "Admin/images/"+UserDefaults.standard.string(forKey: "user_id")!+".png"
            let storageRef = Storage.storage().reference().child(path)
            storageRef.putData(imageData!, metadata:nil) {metadata, error in
                if error == nil && metadata != nil{
                    let user_id = UserDefaults.standard.string(forKey: "user_id")
                    let db = Firestore.firestore()
                    db.collection("users").document(user_id!).updateData(["pfp" : path])
                }
                
            }
        }
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



extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title:"Profile Picture",
                                            message: "How would you like to select a picture?", preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose from Photo Library", style:.default, handler:{ [weak self] _ in
            self?.presentPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style:.default, handler:{ [weak self] _ in
            self?.presentCamera()
        }))
        present(actionSheet, animated: true)
    }
   
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        let sideLength = min(
            selectedImage.size.width,
            selectedImage.size.height
        )
        let sourceSize = selectedImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = selectedImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        let croppedImage = UIImage(cgImage: croppedCGImage)
        self.pfpImageView.image = croppedImage
        imageData = croppedImage.pngData()
        uploadFile()

    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           UIApplication.shared.open(URL)
           return false
       }
}
