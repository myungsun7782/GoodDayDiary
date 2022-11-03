//
//  DiaryTitleCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/11/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

class DiaryTitleCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UITextField
    @IBOutlet weak var titleTextField: UITextField!
    
    // Variable
    var detailDiaryVC: DetailDiaryVC?
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    let TEXT_FIELD_BODER_WIDTH: CGFloat = 1.0
    let TEXT_FIELD_BORDER_RADIUS: CGFloat = 7
    let TEXT_FIELD_PLACE_HOLDER: String = "제목을 입력해주세요."
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureLabel()
        configureTextField()
    }
    
    private func configureLabel() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
    }
    
    private func configureTextField() {
        let FONT_SIZE: CGFloat = 15
        
        titleTextField.delegate = self
        titleTextField.layer.borderWidth = TEXT_FIELD_BODER_WIDTH
        titleTextField.layer.borderColor = ColorManager.shared.getLightGray().cgColor
        titleTextField.layer.cornerRadius = TEXT_FIELD_BORDER_RADIUS
        titleTextField.font = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: FONT_SIZE)
        titleTextField.textColor = .black
        titleTextField.addLeftPadding()
        titleTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getLightGray()])
    }
}

// UITextField
extension DiaryTitleCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let detailDiaryVC = detailDiaryVC {
            detailDiaryVC.configureTextFieldKeyboard()
        }
    }
}
