//
//  ViewController.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit
import FSCalendar
import FirebaseFirestore
import RxSwift
import RxCocoa

final class MainVC: UIViewController {
    // UILabel
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    // FSCalendar
    @IBOutlet weak var calendarView: FSCalendar!
    
    // UIView
    let unRegisteredDiaryView: UnregisteredDiaryView = UnregisteredDiaryView()
    let registeredDiaryView: RegisteredDiaryView = RegisteredDiaryView()
    
    // Variables
    var selectedDateStr: String!
    var selectedDate: Date!
    var registeredDiaryDateList: [String] = Array<String>()
    var diaryList: [Diary] = Array<Diary>()
    
    // Constants
    let CALENDAR_HEADER_DATE_FORMAT = "MMMM  yyyy"
    let LOCALE_IDENTIFIER = "en_US"
    let CALENDAR_HEADER_MINIMUM_DISSOLVED_ALPHA: CGFloat = 0
    let CALENDAR_BORDER_RADIUS: CGFloat = 1
    let UNREGISTERED_DIARY_VIEW_RADIUS: CGFloat = 38
    let UNREGISTERED_DIARY_VIEW_SHADOW_OPACITY: Float = 0.25
    let REGISTERED_DIARY_IMAGE_VIEW_RADIUS: CGFloat = 8
    let REGISTERED_DIARY_BUTTON_RADIUS: CGFloat = 7
    let WEEKDAY_FONT_SIZE: CGFloat = 14
    let CALENDAR_TITLE_FONT_SIZE: CGFloat = 15
    let TITLE_FONT_SIZE: CGFloat = 20
    let CALENDAR_EVENT_OFFSET_X: Double = -0.3
    let CALENDAR_EVENT_OFFSET_Y: Double = -11
    let CALENDAR_HEADER_TITLE_OFFSET_X: Double = -75
    let CALENDAR_HEADER_TITLE_OFFSET_Y: Double = 0
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        initUI()
        action()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.reloadData()
    }
    
    private func initUI() {
        configureLabels()
        configureCalendarView()
    }
    
    private func action() {
        unRegisteredDiaryView.registerButton.rx.tap
            .subscribe(onNext: { _ in
                // MARK: - DetailDiaryVC ?????? ?????? --> ????????? ????????? ??????
                let detailDiaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailDiaryVC") as! DetailDiaryVC
                detailDiaryVC.mainVC = self
                detailDiaryVC.diaryEditorMode = .new
                detailDiaryVC.diaryDate = self.selectedDate
                detailDiaryVC.diaryDelegate = self
                detailDiaryVC.modalPresentationStyle = .overFullScreen
                detailDiaryVC.modalTransitionStyle = .crossDissolve
                
                self.present(detailDiaryVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        registeredDiaryView.seeMoreButton.rx.tap
            .subscribe(onNext: { _ in
                let detailDiaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailDiaryVC") as! DetailDiaryVC
                detailDiaryVC.mainVC = self
                detailDiaryVC.diaryEditorMode = .edit
                detailDiaryVC.diaryDate = self.selectedDate
                detailDiaryVC.diaryDelegate = self
                detailDiaryVC.diaryObj = self.searchDiaryObject(diaryDate: self.selectedDate)
                detailDiaryVC.modalPresentationStyle = .overFullScreen
                detailDiaryVC.modalTransitionStyle = .crossDissolve
                
                self.present(detailDiaryVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setData() {
        // MARK: - Cloud Firestore ???????????? ?????????! -> UserDefaults??? ???????????? ?????? ????????????
        FirebaseManager.shared.fetchDiaryList { diaryList in
            self.diaryList = diaryList
            self.registeredDiaryDateList = []
            self.diaryList.forEach { diary in
                self.registeredDiaryDateList.append(diary.dateStr)
            }
            self.selectedDate = Date() // ?????? ????????? ??????
            self.configureDiaryView(diaryDate: self.selectedDate)
            self.calendarView.reloadData()
        }
    }
    
    private func configureCalendarView() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.weekdayTextColor = ColorManager.shared.getPhilippineGray()
        calendarView.appearance.weekdayFont = FontManager.shared.getAppleSDGothicNeoBold(fontSize: WEEKDAY_FONT_SIZE)
        calendarView.appearance.titlePlaceholderColor = ColorManager.shared.getGainsboro()
        calendarView.locale = Locale(identifier: LOCALE_IDENTIFIER)
        calendarView.appearance.headerDateFormat = CALENDAR_HEADER_DATE_FORMAT
        calendarView.appearance.headerMinimumDissolvedAlpha = CALENDAR_HEADER_MINIMUM_DISSOLVED_ALPHA
        calendarView.appearance.titleFont = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: CALENDAR_TITLE_FONT_SIZE)
        calendarView.appearance.headerTitleFont = FontManager.shared.getAppleSDGothicNeoRegular(fontSize: CALENDAR_TITLE_FONT_SIZE)
        calendarView.appearance.titleTodayColor = ColorManager.shared.getBlue()
        calendarView.appearance.todayColor = ColorManager.shared.getWhite()
        calendarView.appearance.selectionColor = ColorManager.shared.getBlue()
        calendarView.appearance.eventDefaultColor = ColorManager.shared.getBlue()
        calendarView.appearance.eventSelectionColor = ColorManager.shared.getWhite()
        calendarView.appearance.borderRadius = CALENDAR_BORDER_RADIUS
        calendarView.appearance.eventOffset = .init(x: CALENDAR_EVENT_OFFSET_X, y: CALENDAR_EVENT_OFFSET_Y)
        calendarView.appearance.headerTitleOffset = .init(x: CALENDAR_HEADER_TITLE_OFFSET_X, y: CALENDAR_HEADER_TITLE_OFFSET_Y)
        calendarView.appearance.headerTitleAlignment = .left
    }
    
    private func configureLabels() {
        firstTitleLabel.font = FontManager.shared.getAppleSDGothicNeoExtraBold(fontSize: TITLE_FONT_SIZE)
        secondTitleLabel.font = FontManager.shared.getAppleSDGothicNeoExtraBold(fontSize: TITLE_FONT_SIZE)
    }
    
    private func configureUnregisteredDiaryView() {
        unRegisteredDiaryView.alpha = 0
        unRegisteredDiaryView.backgroundColor = ColorManager.shared.getWhite()
        unRegisteredDiaryView.layer.cornerRadius = UNREGISTERED_DIARY_VIEW_RADIUS
        unRegisteredDiaryView.layer.shadowOpacity = UNREGISTERED_DIARY_VIEW_SHADOW_OPACITY
        unRegisteredDiaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unRegisteredDiaryView)
        setUnRegisteredDiaryViewConstraints()
    }
    
    private func setUnRegisteredDiaryViewConstraints() {
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 390
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 250

        NSLayoutConstraint.activate([
            unRegisteredDiaryView.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT),
            unRegisteredDiaryView.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT),
            unRegisteredDiaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            unRegisteredDiaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            unRegisteredDiaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureRegisteredDiaryView() {
        registeredDiaryView.alpha = 0
        registeredDiaryView.backgroundColor = ColorManager.shared.getWhite()
        registeredDiaryView.layer.cornerRadius = UNREGISTERED_DIARY_VIEW_RADIUS
        registeredDiaryView.layer.shadowOpacity = UNREGISTERED_DIARY_VIEW_SHADOW_OPACITY
        registeredDiaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registeredDiaryView)
        setRegisteredDiaryViewConstraints()
        
    }
    
    private func setRegisteredDiaryViewConstraints() {
        let WIDTH_ANCHOR_CONSTANT: CGFloat = 390
        let HEIGHT_ANCHOR_CONSTANT: CGFloat = 305
        
        NSLayoutConstraint.activate([
            registeredDiaryView.widthAnchor.constraint(equalToConstant: WIDTH_ANCHOR_CONSTANT),
            registeredDiaryView.heightAnchor.constraint(equalToConstant: HEIGHT_ANCHOR_CONSTANT),
            registeredDiaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registeredDiaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registeredDiaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDiaryView(diaryDate: Date) {
        // ?????? diaryDate??? ???????????? ???????????? ?????? ??????(Diary Instance ??????)
        if registeredDiaryDateList.contains(TimeManager.shared.dateToYearMonthDay(date: diaryDate)) {
            let diaryObject = searchDiaryObject(diaryDate: diaryDate)
            
            configureRegisteredDiaryView()
            registeredDiaryView.isHidden = false
            unRegisteredDiaryView.isHidden = true
            animateRegisteredDiaryView()
//            registeredDiaryView.dateLabel.text = TimeManager.shared.dateToYearMonthDay(date: diaryObject.date)
            registeredDiaryView.diaryTitleLabel.text = diaryObject.title
            registeredDiaryView.diaryContentsLabel.text = diaryObject.contents
            registeredDiaryView.diaryImageView.image = ImageManager.shared.getImage(.BUTTERFLY_IMAGE)
            guard let photoUrlList = diaryObject.photoUrlList else {
                registeredDiaryView.diaryImageView.image = ImageManager.shared.getImage(.BUTTERFLY_IMAGE)
                return
            }
            if !photoUrlList.isEmpty {
                registeredDiaryView.diaryImageView.fetchImage(photoId: photoUrlList[0])
            } else {
                registeredDiaryView.diaryImageView.image = ImageManager.shared.getImage(.BUTTERFLY_IMAGE)
            }
        } else {
            configureUnregisteredDiaryView()
            unRegisteredDiaryView.isHidden = false
            registeredDiaryView.isHidden = true
            animateUnRegisteredDiaryView()
            unRegisteredDiaryView.dateLabel.text = TimeManager.shared.dateToYearMonthDay(date: diaryDate)
        }
    }
    
    private func animateUnRegisteredDiaryView() {
        UIView.animate(withDuration: 0.5) {
            self.unRegisteredDiaryView.alpha = 1
        } completion: { (completion) in
        }
    }
    
    private func animateRegisteredDiaryView() {
        UIView.animate(withDuration: 0.5) {
            self.registeredDiaryView.alpha = 1
        } completion: { (completion) in
        }
    }
    
    // MARK: diaryDate??? ???????????? diary ????????? ??????????????? ?????????
    private func searchDiaryObject(diaryDate: Date) -> Diary {
        // ??? ???????????? ???????????? ????????? diaryDate??? ?????? diary??? ??????????????? ?????? ?????? ???????????? ????????? diary Instance??? ????????? ??? ?????? ??????.
        var diaryObject: Diary!
        let diaryDateStr = TimeManager.shared.dateToYearMonthDay(date: diaryDate)
        
        for diary in diaryList {
            if diaryDateStr == diary.dateStr {
                diaryObject = diary
                break
            }
        }
        return diaryObject
    }
    
    private func getDiaryObjectIndex(diary: Diary) -> Int {
        var diaryIndex: Int!
        for (idx, diaryObj) in diaryList.enumerated() {
            if diaryObj.diaryId == diary.diaryId {
                diaryIndex = idx
                break
            }
        }
        return diaryIndex
    }
}

extension MainVC: FSCalendarDataSource, FSCalendarDelegate {
    // ??????????????? ????????? ??????????????? ??? ???????????? ?????????
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectedDateStr = TimeManager.shared.dateToYearMonthDay(date: date)
        configureDiaryView(diaryDate: date)
    }
    
    // ???????????? ???????????? ????????? ????????? ??????????????? ?????????
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateStr = TimeManager.shared.dateToYearMonthDay(date: date)
        
        if registeredDiaryDateList.contains(dateStr) {
            return 1
        }
        return 0
    }
}

// DiaryDelegate
extension MainVC: DiaryDelegate {
    func manageDiary(_ diaryObj: Diary, diaryEditorMode: DiaryEditorMode) {
//        selectedDate = diaryObj.date
        if diaryEditorMode == .new {
            // MARK: - ????????? ?????? ??? ?????? ??????
            diaryList.append(diaryObj)
            FirebaseManager.shared.addDiaryData(diary: diaryObj)
            registeredDiaryDateList.append(diaryObj.dateStr)
        } else if diaryEditorMode == .edit {
            // MARK: - ????????? ?????? ??? ?????? ??????
            diaryList[getDiaryObjectIndex(diary: diaryObj)] = diaryObj
            FirebaseManager.shared.modifyDiaryData(diaryId: diaryObj.diaryId, title: diaryObj.title, content: diaryObj.contents, photoUrlList: diaryObj.photoUrlList!)
        } else if diaryEditorMode == .delete {
            // MARK: - ????????? ?????? ??? ?????? ??????
            registeredDiaryDateList.remove(at: getDiaryObjectIndex(diary: diaryObj))
            diaryList.remove(at: getDiaryObjectIndex(diary: diaryObj))
            FirebaseManager.shared.deleteDiaryData(diaryId: diaryObj.diaryId)
        }
        self.configureDiaryView(diaryDate: self.selectedDate)
        self.calendarView.reloadData()
    }
}

