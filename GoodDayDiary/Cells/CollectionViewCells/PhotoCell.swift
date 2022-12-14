//
//  PhotoCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit
import RxSwift

class PhotoCell: UICollectionViewCell {
    // UIImageView
    @IBOutlet weak var photoImageView: UIImageView!
    
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    
    // Constants
    let IMAGE_CORNER_RADIUS: CGFloat = 15
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureImageView()
        configureButton()
    }
    
    private func configureImageView() {
        photoImageView.layer.cornerRadius = IMAGE_CORNER_RADIUS
    }
    
    private func configureButton() {
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
    }
}
