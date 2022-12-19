//
//  Diary.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/30.
//

import UIKit

protocol DiaryDelegate: AnyObject {
    func manageDiary(_ diaryObj: Diary, photoList: [UIImage]?, diaryEditorMode: DiaryEditorMode)
}

struct Diary: Codable {
    var diaryId: String
    var dateStr: String
    var dateTimeStamp: Int
    var title: String
    var contents: String
    var photoUrlList: [String]?
//    var place: String?
}
