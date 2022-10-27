//
//  UnregisteredDiaryView.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/27.
//

import UIKit

class UnregisteredDiaryView: UIView {
    // MARK: - UI 구현
    let pointView: UIView = {
        let X: Int = 0
        let Y: Int = 0
        let WIDTH: Int = 20
        let HEIGHT: Int = 20
        let view = UIView(frame: CGRect(x: X, y: Y, width: WIDTH, height: HEIGHT))
        
        view.makeViewGradient(view: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        let FONT_SIZE: CGFloat = 24
        
        label.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
        label.text = TimeManager.shared.dateToYearMonthDay(date: Date())
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        let DEFAULT_TEXT: String = "당신의 소중한 하루를 기록해주세요 :)"
        let FONT_SIZE: CGFloat = 15
        
        label.font = FontManager.shared.getAppleSDGothicNeoLight(fontSize: FONT_SIZE)
        label.text = DEFAULT_TEXT
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        let BUTTON_TITLE: String = "추가하기"
        let BUTTON_RADIUS: CGFloat = 7
        let FONT_SIZE: CGFloat = 18
        
        button.setTitle(BUTTON_TITLE, for: .normal)
        button.setTitleColor(ColorManager.shared.getWhite(), for: .normal)
        button.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
        button.backgroundColor = ColorManager.shared.getBlue()
        button.layer.cornerRadius = BUTTON_RADIUS
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - 생성자 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    private func initUI() {
        addSubview(pointView)
        addSubview(dateLabel)
        addSubview(defaultLabel)
        addSubview(registerButton)
    }

    // MARK: - 오토 레이아웃 설정
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    private func setConstraints() {
        setPointViewConstraints()
        setLabelConstraints()
        setButtonConstraints()
    }
    
    private func setPointViewConstraints() {
        let TOP_ANCHOR_CONSTANT: CGFloat = 50
        let LEADING_ANCHOR_CONSTANT: CGFloat = 50
        
        NSLayoutConstraint.activate([
            pointView.topAnchor.constraint(equalTo: topAnchor, constant: TOP_ANCHOR_CONSTANT),
            pointView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_ANCHOR_CONSTANT)
        ])
    }
    
    private func setLabelConstraints() {
        let DATE_LABEL_TOP_ANCHOR_CONSTANT: CGFloat = 47.5
        let DATE_LABEL_LEADING_ANCHOR_CONSTANT: CGFloat = 35
        let DEFAULT_LABEL_TOP_ANCHOR_CONSTANT: CGFloat = 20
        let DEFAULT_LABEL_LEADING_ANCHOR_CONSTANT: CGFloat = 85
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: DATE_LABEL_TOP_ANCHOR_CONSTANT),
            dateLabel.leadingAnchor.constraint(equalTo: pointView.trailingAnchor, constant: DATE_LABEL_LEADING_ANCHOR_CONSTANT),
            dateLabel.centerYAnchor.constraint(equalTo: pointView.centerYAnchor),
    
            defaultLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: DEFAULT_LABEL_TOP_ANCHOR_CONSTANT),
            defaultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DEFAULT_LABEL_LEADING_ANCHOR_CONSTANT)
        ])
    }
    
    private func setButtonConstraints() {
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 300
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 60
        let LEADING_ANCHOR_CONSTANT: CGFloat = 50
        let TRAILING_ANCHOR_CONSTANT: CGFloat = -50
        let BOTTOM_ANCHOR_CONSTANT: CGFloat = -46
        
        NSLayoutConstraint.activate([
            registerButton.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT),
            registerButton.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_ANCHOR_CONSTANT),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: TRAILING_ANCHOR_CONSTANT),
            registerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: BOTTOM_ANCHOR_CONSTANT)
        ])
    }
}
