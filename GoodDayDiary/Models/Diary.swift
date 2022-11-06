//
//  Diary.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/30.
//

import UIKit

protocol DiaryDelegate: AnyObject {
    func addDiary(_ diaryObj: Diary, photoList: [UIImage]?)
}

struct Diary {
    var date: Date!
    var title: String!
    var contents: String!
    var photoUrlList: [String]?
//    var place: String?
}
