//
//  PhotoAccess.swift
//  Alpha Draw
//
//  Created by Leonardo Nan on 2022/12/2.
//

import Foundation
import Photos
import UIKit


class PhotoAccess: NSObject {
    static let albumName = "AlphaDraw"
    static let sharedInstance = PhotoAccess()
    var PhotoLibary: [UIImage] = []

    var assetCollection: PHAssetCollection!

    override init() {
        super.init()

        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }

    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }

    func createAlbum() {
        let albumName = PhotoAccess.albumName
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
                print("Create an album '\(albumName)'")
            } else {
                print("error \(String(describing: error))")
            }
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoAccess.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }

    func save(image: UIImage) {
        if let assetCol = self.assetCollection {
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCol)
                let enumeration: NSArray = [assetPlaceHolder!]
                albumChangeRequest!.addAssets(enumeration)

            }, completionHandler: nil)
            PhotoLibary.append(image)
        }
    }
    
    func loadPhotos() {
//        DispatchQueue.global(qos: .userInteractive).async
//        {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

            let imgManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat

            if let assetCol = self.assetCollection {
                let photoInAlbum = PHAsset.fetchAssets(in: assetCol, options: fetchOptions)

                print("\n \(PhotoAccess.albumName) --- count = \(photoInAlbum.count) \n")
                for idx in (0..<photoInAlbum.count) {
                    imgManager.requestImage(for: photoInAlbum.object(at: idx) as PHAsset , targetSize: CGSize(width: 0, height: 0), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                        imageResult, error in
                        if let image = imageResult  {
                            self.PhotoLibary.append(image)
                        }
                    })
                }
            }
        }
//    }
}
