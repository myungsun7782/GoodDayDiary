//
//  DiaryButtonCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/11/01.
//

import UIKit

class DiaryButtonCell: UITableViewCell {
    // UIButton
    @IBOutlet weak var finishButton: UIButton!
    
    // Constants
    let BUTTON_FONT_SIZE: CGFloat = 18
    let BUTTON_BORDER_RADIUS: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureButton()
    }
    
    private func configureButton() {
        finishButton.backgroundColor = ColorManager.shared.getBlue()
        finishButton.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: BUTTON_FONT_SIZE)
        finishButton.layer.cornerRadius = BUTTON_BORDER_RADIUS
    }
}
