//
//  DiaryDateCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit

class DiaryDateCell: UITableViewCell {
    // UIView
    @IBOutlet weak var pointView: UIView!
    
    // UILabel
    @IBOutlet weak var diaryDateLabel: UILabel!
    
    // UILabel
    @IBOutlet weak var deleteButton: UIButton!
    
    // Constants
    let FONT_SIZE: CGFloat = 24
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureDiaryDateLabel()
    }
    
    private func configureDiaryDateLabel() {
        diaryDateLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
    }
    
    func setDiaryDate(diaryDate: Date) {
        diaryDateLabel.text = TimeManager.shared.dateToYearMonthDay(date: diaryDate)
    }
    
    func configureDeleteButton(diaryEditorMode: DiaryEditorMode) {
        deleteButton.isHidden = diaryEditorMode == .new ? true : false
    }
}
