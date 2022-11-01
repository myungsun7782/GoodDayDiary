//
//  DiaryPlaceCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit

class DiaryPlaceCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    let DESCRIPTION_FONT_SIZE: CGFloat = 14
    let CONTAINER_VIEW_RADIUS: CGFloat = 7
    let CONTAINER_VIEW_BORDER_WIDTH: CGFloat = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    private func initUI() {
        configureLabels()
        configureContainerView()
    }
    
    private func configureLabels() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
        descriptionLabel.font = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: DESCRIPTION_FONT_SIZE)
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = CONTAINER_VIEW_RADIUS
        containerView.layer.borderWidth = CONTAINER_VIEW_BORDER_WIDTH
        containerView.layer.borderColor = ColorManager.shared.getLightGray().cgColor
    }
}
