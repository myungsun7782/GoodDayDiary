//
//  Diary.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/30.
//

import UIKit

protocol DiaryDelegate: AnyObject {
    func addDiary(_ diaryObj: Diary)
}

struct Diary {
    var date: String!
    var title: String!
    var contents: String!
    var photoUrlList: [String]?
//    var place: String?
}
