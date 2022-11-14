//
//  FirebaseManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    private let COLLECTION_NAME: String = "users"
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let storageUrl = "gs://gooddaydiary-74ec4.appspot.com/"
    
    private init() {}
    
    func uploadImage(imgList: Array<UIImage>, handler: @escaping (_ photoIdList: Array<String>) -> ()) {
        var photoIdList = Array<(String, Bool)>() // @param1: photoId, @param2: isDone
        
        for _ in imgList {
            photoIdList.append((UUID().uuidString, false))
        }
        
        for (idx, img) in imgList.enumerated() {
            var data = Data()
            data = img.jpegData(compressionQuality: 0.8)!
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            storage.reference().child(photoIdList[idx].0).putData(data, metadata: metaData) { (md, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("Successfully Upload Photo")
                    photoIdList[idx].1 = true
                    if self.isImageListUploadDone(photoIdList: photoIdList) {
                        var resultList = Array<String>()
                        
                        for p in photoIdList {
                            resultList.append(p.0)
                        }
                        handler(resultList)
                    }
                }
            }
        }
    }
    
    private func isImageListUploadDone(photoIdList: Array<(String, Bool)>) -> Bool {
        for photoId in photoIdList {
            if !photoId.1 {
                return false
            }
        }
        return true
    }
    
    func uploadImage(img: UIImage, filePath: String) {
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata: metaData) { (md, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Successfully Upload Photo")
            }
        }
    }
    
    func downloadImage(photoFilePath: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: storageUrl + photoFilePath)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}
