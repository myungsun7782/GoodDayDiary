//
//  AddPhotoCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // Constants
    let VIEW_CORNER_RADIUS: CGFloat = 15
    let VIEW_BORDER_WIDTH: CGFloat = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureContainerView()
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = VIEW_CORNER_RADIUS
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = VIEW_BORDER_WIDTH
        containerView.backgroundColor = ColorManager.shared.getWhite()
    }
}
