//
//  DiaryDateCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa

class DiaryDateCell: UITableViewCell {
    // UIView
    @IBOutlet weak var pointView: UIView!
    
    // UILabel
    @IBOutlet weak var diaryDateLabel: UILabel!
    
    // UILabel
    @IBOutlet weak var deleteButton: UIButton!
    
    // Variables
    var detailDiaryVC: DetailDiaryVC?
    
    // Constants
    let FONT_SIZE: CGFloat = 24
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        action()
    }
    
    private func initUI() {
        configureDiaryDateLabel()
    }
    
    private func action() {
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentDeleteAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureDiaryDateLabel() {
        diaryDateLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: FONT_SIZE)
    }
    
    func setDiaryDate(diaryDate: Date) {
        diaryDateLabel.text = TimeManager.shared.dateToYearMonthDay(date: diaryDate)
    }
    
    func configureDeleteButton(diaryEditorMode: DiaryEditorMode) {
        deleteButton.isHidden = diaryEditorMode == .new ? true : false
    }
    
    private func presentDeleteAlert() {
        guard let detailDiaryVC = detailDiaryVC else { return }
        let alert = UIAlertController(title: "삭제", message: "정말로 해당 날짜의 일기를 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            detailDiaryVC.diaryDelegate?.manageDiary(detailDiaryVC.diaryObj!, photoList: detailDiaryVC.photoList, diaryEditorMode: .delete)
            detailDiaryVC.dismiss(animated: true)
        }
        let cancelButon = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButon)
        detailDiaryVC.present(alert, animated: true)
    }
}
