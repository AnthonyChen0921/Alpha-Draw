//
//  Firebase.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/22/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

// Firebase class
// This class is used to setup db, call functions, and upload images to firebase
// To use the function, you will need to initialize the class in any view controller,
// Feel free to overload the functions and add more functions
class Firebase {
    var db: Firestore = Firestore.firestore()
    var uploadTask: StorageUploadTask?
    var size: Int64?

    
    // MARK: - Image Functions
    /**
        *  @brief: Upload image to firebase storage
        *  @param: image: UIImage
        *  @param: id: String
        *  @param: userId: String? = "Admin"
        *  @param: completion: @escaping (String) -> Void
        *  @return: void
        */
    func uploadImageToStorage(image: UIImage, id: String, userid: String? = "Admin", imageType: String? = "Image",completion: @escaping (String) -> Void) {
        // store UIimage locally temporarily
        let data = image.pngData()
        let tempDir = NSTemporaryDirectory()
        let tempFile = tempDir.appending("image.png")
        let url = URL(fileURLWithPath: tempFile)
        do {
            try data?.write(to: url)
        } catch {
            print("error")
        }

        // upload stored image to firebase storage from tmp folder
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("/\(userid!)/\(imageType!)/\(id).png")
            uploadTask = imageRef.putFile(from: url, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            self.size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                // print(downloadURL)
                completion(downloadURL.absoluteString)
            }
        }
    }

    /**
        *  @brief: Get image from firebase storage
        *  @param: id: String
        *  @param: userId: String? = "Admin"
        *  @param: completion: @escaping (UIImage) -> Void
        *  @return: void
        */
    func getImageFromStorageById(id: String, userid: String? = "Admin", imageType: String? = "Image",completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("/\(userid!)/\(imageType!)/\(id).png")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                let image = UIImage(data: data!)
                completion(image!)
            }
        }
    }

    
    /**
        *  @brief: Upload pokemon image url to firebase firestore by id
        *  @param: id: String
        *  @param: url: String
        *  @param: userId: String? = "Admin"
        *  @return: void
        */
    func uploadImageUrl(id: String, url: String, imageType: String? = "Image",userid: String? = "Admin") {
        // path is :userid -> PokemonImage -> id
        let docRef = db.collection(userid!).document("Image").collection(imageType!).document(id)
        docRef.setData([
            "url": url
        ], merge: true)
    }

    /**
        *  @brief: Get pokemon image url from firebase firestore by id
        *  @param: id: String
        *  @param: userId: String? = "Admin"
        *  @return: void
        */
    func getImageUrlById(id: String, userid: String? = "Admin", imageType: String? = "Image") -> String {
        var url: String = ""
        let docRef = db.collection(userid!).document("Image").collection(imageType!).document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                url = document.get("url") as! String
            } else {
                print("Document does not exist")
            }
        }
        return url
    }


    /**
        *  @brief: Get All Image Urls by Types under a user, return a dictionary of image urls
        *  @param: id: String
        *  @param: url: String
        *  @param: userId: String? = "Admin"
        *  @return: void
        */
    func getAllImageUrlsByTypes(userid: String? = "Admin", imageType: String? = "Image") -> [String] {
        var urls: [String] = []
        let docRef = db.collection(userid!).document("Image").collection(imageType!)
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    urls.append(document.get("url") as! String)
                }
            }
        }
        return urls
    }

    // MARK: - User Functions
    /**
        *  @brief: Add user to firebase firestore
        *  @param: user: User
        *  @return: void
        */
    func addUser(user: User) {
        do {
            let _ = try db.collection("Users").addDocument(from: user)
        } catch {
            print(error)
        }
    }

    

}
