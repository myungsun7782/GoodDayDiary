//
//  DetailDiaryVC.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit
import Photos
import YPImagePicker
import RxKeyboard
import RxSwift
import SnapKit

class DetailDiaryVC: UIViewController {
    // UILabel
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // UITableView
    @IBOutlet weak var diaryTableView: UITableView!
    
    // UIStackView
    @IBOutlet weak var diaryStackView: UIStackView!
        
    // NSLayoutConstraint
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // Variables
    var photoList = Array<UIImage>()
    var diaryEditorMode: DiaryEditorMode!
    var diaryDate: Date!
    var diaryDelegate: DiaryDelegate?
    
    // Constants
    let SECTION_COUNT: Int = 1
    let TABLE_VIEW_NUMBER_OF_SECTIONS: Int = 4
    let CONTENTS_PLACE_HOLDER = "당신의 소중한 하루를 기록해주세요 :)"
    let TITLE_FONT_SIZE: CGFloat = 20
    let BUTTON_FONT_SIZE: CGFloat = 18
    let BUTTON_BORDER_RADIUS: CGFloat = 7
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
    }
    
    private func initUI() {
        configureLabels()
        configureTableView()
        configureButton()
    }
    
    private func action() {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        diaryTableView.addGestureRecognizer(tap)
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        diaryTableView.register(UINib(nibName: "DiaryDateCell", bundle: nil), forCellReuseIdentifier: "DiaryDateCell")
        diaryTableView.register(UINib(nibName: "DiaryTitleContentCell", bundle: nil), forCellReuseIdentifier: "DiaryTitleContentCell")
        diaryTableView.register(UINib(nibName: "DiaryPlaceCell", bundle: nil), forCellReuseIdentifier: "DiaryPlaceCell")
        diaryTableView.register(UINib(nibName: "DiaryPhotoCell", bundle: nil), forCellReuseIdentifier: "DiaryPhotoCell")
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configureLabels() {
        firstTitleLabel.font = FontManager.shared.getAppleSDGothicNeoExtraBold(fontSize: TITLE_FONT_SIZE)
        secondTitleLabel.font = FontManager.shared.getAppleSDGothicNeoExtraBold(fontSize: TITLE_FONT_SIZE)
    }
    
    private func configureButton() {
        finishButton.backgroundColor = ColorManager.shared.getBlue()
        finishButton.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: BUTTON_FONT_SIZE)
        finishButton.titleLabel?.textColor = ColorManager.shared.getWhite()
        finishButton.layer.cornerRadius = BUTTON_BORDER_RADIUS
    }
    
    func presentPhotoMaxAlert() {
        // TODO: Show alert
        let alert = UIAlertController(title: nil, message: "사진은 최대 5장까지 등록할 수 있습니다.", preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmButton)
        present(alert, animated: true, completion: nil)
    }
    
    func presentImagePicker(numPhotoMax: Int) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.library.mediaType = .photo
        config.screens = [.library]
        config.showsPhotoFilters = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    self.photoList.append(photo.image)
                case .video(_):
                    continue
                }
            }
            
            self.diaryTableView.reloadData()
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func presentDetailImageVC(detailImage: UIImage) {
        let detailImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailImageVC") as! DetailImageVC
        
        detailImageVC.detailImage = detailImage
        detailImageVC.modalTransitionStyle = .crossDissolve
        detailImageVC.modalPresentationStyle = .overFullScreen
        present(detailImageVC, animated: true)
    }
    
    func configureTextViewKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight+view.safeAreaInsets.bottom-10 : 0
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomConstraint.constant = -height
                }, completion: { _ in
                    DispatchQueue.main.async {
                        self.diaryTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    func configureTextFieldKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + view.safeAreaInsets.bottom - 10 : 0
                
                self.finishButton.snp.updateConstraints {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(height)
                }
                view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    func validateInputField(titleTextField: UITextField, contentTextView: UITextView) {
        finishButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && !(contentTextView.text.isEmpty) && (contentTextView.text != CONTENTS_PLACE_HOLDER)
    
            if finishButton.isEnabled {
                finishButton.backgroundColor = ColorManager.shared.getBlue()
                finishButton.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: BUTTON_FONT_SIZE)
        }else {
            finishButton.backgroundColor = ColorManager.shared.getChineseSilver()
            finishButton.titleLabel?.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: BUTTON_FONT_SIZE)
        }
    }
}

// UITableView
extension DetailDiaryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SECTION_COUNT
        } else if section == 1 {
            return SECTION_COUNT
        } else if section == 2 {
            return SECTION_COUNT
        } else if section == 3 {
            return SECTION_COUNT
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryDateCell", for: indexPath) as! DiaryDateCell
            
            cell.pointView.makeViewGradient(view: cell.pointView)
            cell.setDiaryDate(diaryDate: diaryDate)
            cell.configureDeleteButton(diaryEditorMode: diaryEditorMode)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTitleContentCell", for: indexPath) as! DiaryTitleContentCell
            cell.detailDiaryVC = self
            validateInputField(titleTextField: cell.titleTextField, contentTextView: cell.contentTextView)
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPlaceCell", for: indexPath) as! DiaryPlaceCell

            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPhotoCell", for: indexPath) as! DiaryPhotoCell
            cell.setData(detailDiaryVC: self, photoList: photoList)
            
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return TABLE_VIEW_NUMBER_OF_SECTIONS
    }
}
