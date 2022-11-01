//
//  DiaryPhotoCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit

class DiaryPhotoCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UICollectionView
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureLabel()
    }
    
    private func configureLabel() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
    }
}

