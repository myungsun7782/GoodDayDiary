//
//  DiaryContentCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/11/01.
//

import UIKit

class DiaryContentCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UITextView
    @IBOutlet weak var contentTextView: UITextView!
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    let TEXTFIELD_BODER_WIDTH: CGFloat = 1.0
    let TEXTFIELD_BORDER_RADIUS: CGFloat = 7
    let CONTENTS_PLACE_HOLDER = "당신의 소중한 하루를 기록해주세요 :)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureLabels()
        configureTextView()
    }
    
    private func configureLabels() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
    }
    
    private func configureTextView() {
        let TOP_EDGE_INSET: CGFloat = 16
        let LEFT_EDGE_INSET: CGFloat = 8
        let RIGHT_EDGE_INSET: CGFloat = 8
        let BOTTOM_EDGE_INSET: CGFloat = 8
        let FONT_SIZE: CGFloat = 15
        
        contentTextView.layer.borderWidth = TEXTFIELD_BODER_WIDTH
        contentTextView.layer.borderColor = ColorManager.shared.getLightGray().cgColor
        contentTextView.layer.cornerRadius = TEXTFIELD_BORDER_RADIUS
        contentTextView.textContainerInset = UIEdgeInsets(top: TOP_EDGE_INSET, left: LEFT_EDGE_INSET, bottom: BOTTOM_EDGE_INSET, right: RIGHT_EDGE_INSET)
        contentTextView.font = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: FONT_SIZE)
        contentTextView.text = CONTENTS_PLACE_HOLDER
        contentTextView.textColor = ColorManager.shared.getLightGray()
    }

    
    
    
}
