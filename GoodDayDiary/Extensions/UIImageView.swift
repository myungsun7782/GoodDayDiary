//
//  UIImageView.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/11/09.
//

import Foundation
import FirebaseStorage
import FirebaseStorageUI

extension UIImageView {
    func fetchImage(photoId: String) {
        let ref = Storage.storage().reference().child(photoId)
        self.sd_setImage(with: ref)
    }
}
