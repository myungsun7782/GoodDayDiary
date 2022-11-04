//
//  DiaryTitleContentCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/11/04.
//

import UIKit

class DiaryTitleContentCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // UITextField
    @IBOutlet weak var titleTextField: UITextField!
    
    // UITextView
    @IBOutlet weak var contentTextView: UITextView!
    
    // Variable
    var detailDiaryVC: DetailDiaryVC?
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    let TEXT_FIELD_BODER_WIDTH: CGFloat = 1.0
    let TEXT_FIELD_BORDER_RADIUS: CGFloat = 7
    let TEXT_FIELD_PLACE_HOLDER: String = "제목을 입력해주세요."
    let TEXT_VIEW_BODER_WIDTH: CGFloat = 1.0
    let TEXT_VIEW_BORDER_RADIUS: CGFloat = 7
    let CONTENTS_PLACE_HOLDER = "당신의 소중한 하루를 기록해주세요 :)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureLabels()
        configureTextField()
        configureTextView()
    }

    private func configureLabels() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
        contentLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
    }
    
    private func configureTextField() {
        let FONT_SIZE: CGFloat = 15
        
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(DidTitleTextFiledChange(_:)), for: .editingChanged)
        titleTextField.layer.borderWidth = TEXT_FIELD_BODER_WIDTH
        titleTextField.layer.borderColor = ColorManager.shared.getLightGray().cgColor
        titleTextField.layer.cornerRadius = TEXT_FIELD_BORDER_RADIUS
        titleTextField.font = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: FONT_SIZE)
        titleTextField.textColor = .black
        titleTextField.addLeftPadding()
        titleTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getLightGray()])
    }
    
    @objc private func DidTitleTextFiledChange(_ textField: UITextField) {
        if let detailDiaryVC = detailDiaryVC {
            detailDiaryVC.validateInputField(titleTextField: titleTextField, contentTextView: contentTextView)
        }
    }
    
    private func configureTextView() {
        let TOP_EDGE_INSET: CGFloat = 16
        let LEFT_EDGE_INSET: CGFloat = 8
        let RIGHT_EDGE_INSET: CGFloat = 8
        let BOTTOM_EDGE_INSET: CGFloat = 8
        let FONT_SIZE: CGFloat = 15
        
        contentTextView.delegate = self
        contentTextView.layer.borderWidth = TEXT_VIEW_BODER_WIDTH
        contentTextView.layer.borderColor = ColorManager.shared.getLightGray().cgColor
        contentTextView.layer.cornerRadius = TEXT_VIEW_BORDER_RADIUS
        contentTextView.textContainerInset = UIEdgeInsets(top: TOP_EDGE_INSET, left: LEFT_EDGE_INSET, bottom: BOTTOM_EDGE_INSET, right: RIGHT_EDGE_INSET)
        contentTextView.font = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: FONT_SIZE)
        contentTextView.text = CONTENTS_PLACE_HOLDER
        contentTextView.textColor = ColorManager.shared.getLightGray()
    }
}

// UITextField
extension DiaryTitleContentCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let detailDiaryVC = detailDiaryVC {
            detailDiaryVC.configureTextFieldKeyboard()
        }
    }
}

// UITextView
extension DiaryTitleContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == CONTENTS_PLACE_HOLDER {
            textView.text = nil
            textView.textColor = .black
        }
        
        if let detailDiaryVC = detailDiaryVC {
            detailDiaryVC.configureTextViewKeyboard()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = CONTENTS_PLACE_HOLDER
            textView.textColor = ColorManager.shared.getLightGray()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let detailDiaryVC = detailDiaryVC {
            detailDiaryVC.validateInputField(titleTextField: titleTextField, contentTextView: contentTextView)
        }
    }
}

