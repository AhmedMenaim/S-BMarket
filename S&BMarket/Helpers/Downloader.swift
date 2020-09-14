//
//  Downloader.swift
//  S&BMarket
//
//  Created by Crypto on 8/24/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation
import FirebaseStorage

let myStorage = Storage.storage()

func uploadImages (images: [UIImage?], itemID: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    
    if Reachability.isConnectedToNetwork() {
        
        var uploadImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            let fileName = "ItemImages" + itemID + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)!
            
            saveImagesToFirebase(imageData: imageData, imageFile: fileName) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
                
            }
            nameSuffix += 1
        }
        
    }
    else {
        // Test
        print("No Internet")
    }
}


// MARK: - Save images to Firebase
func saveImagesToFirebase (imageData: Data,imageFile: String, completion: @escaping (_ imageLink: String?) -> Void ) {
    var storeTask: StorageUploadTask!
    let storageRef = myStorage.reference(forURL: storageRefrenceLink).child(imageFile)
    storeTask = storageRef.putData(imageData, metadata: nil, completion: { (myMetaData, error) in
        storeTask.removeAllObservers()
        if error != nil {
            print("Error details is: ", error!.localizedDescription)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        }
    })
}

func downloadImages(imageURLs: [String], completion: @escaping(_ downloadedImages: [UIImage?])-> Void){
    
    var imagesArray: [UIImage] = []
    var downloadCounter = 0
    
    for link in imageURLs {
        let url = NSURL (string: link)
        let downloadQueue = DispatchQueue(label: "imagesDownloadQueue")
        // We used downloadQueue as we want to download files on background not to block the app and wait for downloading
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                imagesArray.append(UIImage(data: data! as Data)!)
                if downloadCounter == imagesArray.count {
                    DispatchQueue.main.async {
                        completion(imagesArray)
                    }
                }
            }
            else {
                print("Download failed")
            }
        }
    }
}
