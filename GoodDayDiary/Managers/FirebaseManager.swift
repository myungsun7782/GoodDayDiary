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
    private let COLLECTION_NAME: String = "diaries"
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let storageUrl = "gs://gooddaydiary-74ec4.appspot.com/"
    private let userUid = UserDefaultsManager.shared.getUserUid()
    
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
    
    func addDiaryData(diary: Diary) {
        var diaryListItem = [Any]()
        
        do {
            let jsonData = try JSONEncoder().encode(diary)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            diaryListItem.append(jsonObject)
        } catch {}
        
        if !UserDefaultsManager.shared.getIsCloudFireStoreInitialized() {
            db.collection(COLLECTION_NAME).document(userUid).setData([userUid: diaryListItem]) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document Successfully Created")
                    UserDefaultsManager.shared.setIsCloudFireStoreInitialized()
                }
            }
        } else {
            db.collection(COLLECTION_NAME).document(UserDefaultsManager.shared.getUserUid()).updateData([
                UserDefaultsManager.shared.getUserUid(): FieldValue.arrayUnion(diaryListItem)
            ])
        }
    }
    
    func fetchDiaryList(completionHandler: @escaping (_ diaryList: [Diary]) -> ()) {
        var diaryObjList: [Diary] = Array<Diary>()
        
        db.collection(COLLECTION_NAME).document(userUid).getDocument { (document, error) in
            if let document = document {
                if let diaryList = (document[self.userUid] as? [[String: Any]]) {
                    for (idx, _) in diaryList.enumerated() {
                        let diaryId = diaryList[idx][DiaryCodingKeys.diaryId.rawValue] as! String
                        let diaryDateStr = diaryList[idx][DiaryCodingKeys.dateStr.rawValue] as! String
                        let diaryDateTimeStamp = diaryList[idx][DiaryCodingKeys.dateTimeStamp.rawValue] as! Int
                        let title = diaryList[idx][DiaryCodingKeys.title.rawValue] as! String
                        let contents = diaryList[idx][DiaryCodingKeys.contents.rawValue] as! String
                        let photoUrlList = diaryList[idx][DiaryCodingKeys.photoUrlList.rawValue] as! [String]
                        
                        let diary = Diary(diaryId: diaryId,
                                          dateStr: diaryDateStr,
                                          dateTimeStamp: diaryDateTimeStamp,
                                          title: title,
                                          contents: contents,
                                          photoUrlList: photoUrlList)
                        diaryObjList.append(diary)
                    }
                    completionHandler(diaryObjList)
                }
            }
        }
    }
    
    func modifyDiaryData(diaryId: String, title: String, content: String, photoUrlList: [String]) {
        FirebaseManager.shared.fetchDiaryList { diaryList in
            var diaryListItem = [Any]()
            var diaryObjList = diaryList
            
            for (idx, diaryObj) in diaryObjList.enumerated() {
                if diaryObj.diaryId == diaryId {
                    diaryObjList[idx].title = title
                    diaryObjList[idx].contents = content
                    diaryObjList[idx].photoUrlList = photoUrlList
                }
            }
            
            for diaryObj in diaryObjList {
                do {
                    let jsonData = try JSONEncoder().encode(diaryObj)
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    diaryListItem.append(jsonObject)
                } catch {}
            }
            
            self.db.collection(self.COLLECTION_NAME).document(self.userUid).setData([self.userUid: diaryListItem]) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document Successfully Update")
                }
            }
        }
    }
    
    func deleteDiaryData(diaryId: String) {
        FirebaseManager.shared.fetchDiaryList { diaryList in
            var diaryListItem = [Any]()
            let diaryObjList = diaryList
            
            for diaryObj in diaryObjList {
                if diaryObj.diaryId == diaryId {
                    do {
                        let jsonData = try JSONEncoder().encode(diaryObj)
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        diaryListItem.append(jsonObject)
                    } catch {}
                    
                    self.db.collection(self.COLLECTION_NAME).document(self.userUid).updateData([
                        self.userUid: FieldValue.arrayRemove(diaryListItem)
                    ])
                    break
                }
            }
        }
    }
}
