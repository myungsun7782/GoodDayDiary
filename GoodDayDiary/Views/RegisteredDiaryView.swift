//
//  RegisteredDiaryView.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/28.
//

import UIKit

class RegisteredDiaryView: UIView {
    // MARK: - UI 구현
    let pointViewImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        let IMAGE_NAME = "PointViewImage"
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 20
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 20
        
        imageView.image = UIImage(named: IMAGE_NAME)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT).isActive = true
        
        return imageView
        
    }()
    
    lazy var containerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateLabel])

        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        let FONT_SIZE: CGFloat = 18
        
        label.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
        label.text = TimeManager.shared.dateToYearMonthDay(date: Date())
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var topStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [pointViewImageView, containerStackView])
        
        sv.spacing = 12
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
       
        return sv
    }()
    
    lazy var diaryImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let diaryTitleLabel: UILabel = {
        let label = UILabel()
        let FONT_SIZE: CGFloat = 18
        
        label.font = FontManager.shared.getAppleSDGothicNeoExtraBold(fontSize: FONT_SIZE)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Diary Title"
        
        return label
    }()
    
    let diaryContentsLabel: UILabel = {
        let label = UILabel()
        let FONT_SIZE: CGFloat = 14
        
        label.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
        label.textColor = ColorManager.shared.getDarkGray()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Diary Contents"
        
        return label
    }()
    
    lazy var middleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [diaryTitleLabel, diaryContentsLabel])
        
        sv.spacing = 10
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton()
        let BUTTON_TITLE: String = "더보기"
        let BUTTON_RADIUS: CGFloat = 7
        let FONT_SIZE: CGFloat = 18
        
        button.backgroundColor = ColorManager.shared.getBlue()
        button.setTitle(BUTTON_TITLE, for: .normal)
        button.setTitleColor(ColorManager.shared.getWhite(), for: .normal)
        button.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
        button.layer.cornerRadius = BUTTON_RADIUS
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topStackView)
        addSubview(diaryImageView)
        addSubview(middleStackView)
        addSubview(seeMoreButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    
    private func setConstraints() {
        setTopStackViewConstraints()
        setImageViewConstraints()
        setMiddleStackViewConstraints()
        setButtonConstraints()
    }
    
    private func setTopStackViewConstraints() {
        let TOP_ANCHOR_CONSTANT: CGFloat = 30
        let LEADING_ANCHOR_CONSTANT: CGFloat = 50
        let BOTTOM_ANCHOR_CONSTANT: CGFloat = -10
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: TOP_ANCHOR_CONSTANT),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_ANCHOR_CONSTANT),
            topStackView.bottomAnchor.constraint(equalTo: diaryImageView.topAnchor, constant: BOTTOM_ANCHOR_CONSTANT)
        ])
    }
    
    private func setImageViewConstraints() {
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 100
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 100
        let LEADING_ANCHOR_CONSTANT: CGFloat = 50
        let TOP_ANCHOR_CONSTANT: CGFloat = 30
        let BOTTOM_ANCHOR_CONSTANT: CGFloat = -24
        
        NSLayoutConstraint.activate([
            diaryImageView.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT),
            diaryImageView.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT),
            diaryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_ANCHOR_CONSTANT),
            diaryImageView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: TOP_ANCHOR_CONSTANT),
            diaryImageView.bottomAnchor.constraint(equalTo: seeMoreButton.topAnchor, constant: BOTTOM_ANCHOR_CONSTANT)
        ])
    }
    
    private func setMiddleStackViewConstraints() {
        let LEADING_ANCHOR_CONSTANT: CGFloat = 24
        let TRAILING_ANCHOR_CONSTANT: CGFloat = -24
        
        NSLayoutConstraint.activate([
            middleStackView.centerYAnchor.constraint(equalTo: diaryImageView.centerYAnchor),
            middleStackView.leadingAnchor.constraint(equalTo: diaryImageView.trailingAnchor, constant: LEADING_ANCHOR_CONSTANT),
            middleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: TRAILING_ANCHOR_CONSTANT)
        ])
    }
    
    private func setButtonConstraints() {
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 300
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 60
        let LEADING_ANCHOR_CONSTANT: CGFloat = 50
        let TRAILING_ANCHOR_CONSTANT: CGFloat = -50
        let BOTTOM_ANCHOR_CONSTANT: CGFloat = -46
        
        NSLayoutConstraint.activate([
            seeMoreButton.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT),
            seeMoreButton.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT),
            seeMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_ANCHOR_CONSTANT),
            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: TRAILING_ANCHOR_CONSTANT),
            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: BOTTOM_ANCHOR_CONSTANT)
        ])
    }
}
