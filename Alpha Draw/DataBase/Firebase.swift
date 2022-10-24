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


class Firebase {
    var db: Firestore = Firestore.firestore()

    var uploadTask: StorageUploadTask?
    var size: Int64?

    
    
    /**
     *  @brief: upload image to firebase storage: gs://alpha-draw-e79cd.appspot.com
     *  @param: image: UIImage
     */
    func uploadImage(image: UIImage, id: String, completion: @escaping (String) -> Void) {
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
        let imageRef = storageRef.child("PokemonImage/\(id).png")
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
                print(downloadURL)
                completion(downloadURL.absoluteString)
            }
        }
    }
    

}
