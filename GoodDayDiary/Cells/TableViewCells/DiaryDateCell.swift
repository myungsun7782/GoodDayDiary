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
}
