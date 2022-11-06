//
//  ViewController.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit
import FSCalendar
import FirebaseFirestore

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.reloadData()
    }
    
    private func initUI() {
        configureLabels()
        configureCalendarView()
        configureDiaryView(diaryDate: Date())
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
        setUpRegisterButtonAction()
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
        setUpSeeMoreButtonAction()
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
    
    private func setUpRegisterButtonAction() {
        unRegisteredDiaryView.registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
    }
    
    @objc private func tapRegisterButton() {
        // MARK: - DetailDiaryVC 화면 이동 --> 새로운 일기장 추가
        let detailDiaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailDiaryVC") as! DetailDiaryVC
        
        detailDiaryVC.diaryEditorMode = .new
        detailDiaryVC.diaryDate = selectedDate
        detailDiaryVC.diaryDelegate = self
        detailDiaryVC.modalPresentationStyle = .overFullScreen
        detailDiaryVC.modalTransitionStyle = .crossDissolve
        
        present(detailDiaryVC, animated: true)
    }
    
    private func setUpSeeMoreButtonAction() {
        registeredDiaryView.seeMoreButton.addTarget(self, action: #selector(tapSeeMoreButton), for: .touchUpInside)
    }
    
    @objc private func tapSeeMoreButton() {
        // MARK: - DetailDiaryVC 화면 이동 --> 기존 일기장 수정
        let detailDiaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailDiaryVC") as! DetailDiaryVC
        
        detailDiaryVC.diaryEditorMode = .edit
        detailDiaryVC.diaryDate = selectedDate
        detailDiaryVC.diaryDelegate = self
        detailDiaryVC.modalPresentationStyle = .overFullScreen
        detailDiaryVC.modalTransitionStyle = .crossDissolve
        
        present(detailDiaryVC, animated: true)
    }
    
    private func configureDiaryView(diaryDate: Date) {
        // 해당 diaryDate에 일기장이 등록되어 있는 경우(Diary Instance 존재)
        if registeredDiaryDateList.contains(TimeManager.shared.dateToYearMonthDay(date: diaryDate)) {
            let diaryObject = searchDiaryObject(diaryDate: diaryDate)
            
            configureRegisteredDiaryView()
            registeredDiaryView.isHidden = false
            unRegisteredDiaryView.isHidden = true
            animateRegisteredDiaryView()
            registeredDiaryView.dateLabel.text = TimeManager.shared.dateToYearMonthDay(date: diaryObject.date)
            registeredDiaryView.diaryTitleLabel.text = diaryObject.title
            registeredDiaryView.diaryContentsLabel.text = diaryObject.contents
//            guard let photoIdList = diaryObject.photoUrlList else {
//                registeredDiaryView.diaryImageView.image = UIImage(named: "SplashImage")
//                return
//            }
//            FirebaseManager.shared.downloadImage(photoFilePath: photoIdList[0]) { [weak self] image in
//                self!.registeredDiaryView.diaryImageView.image = image
//            }
        } else {
            selectedDate = diaryDate
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
    
    // MARK: diaryDate에 해당하는 diary 객체를 반환해주는 메소드
    private func searchDiaryObject(diaryDate: Date) -> Diary {
        // 이 메소드를 호출하는 경우는 diaryDate에 해당 diary가 존재한다는 가정 하에 실행하기 때문에 diary Instance가 존재할 수 밖에 없음.
        var diaryObject: Diary!
        let diaryDateStr = TimeManager.shared.dateToYearMonthDay(date: diaryDate)
        
        for diary in diaryList {
            if diaryDateStr == TimeManager.shared.dateToYearMonthDay(date: diary.date) {
                diaryObject = diary
                break
            }
        }
        return diaryObject
    }
}

extension MainVC: FSCalendarDataSource, FSCalendarDelegate {
    // 캘린더에서 날짜가 선택되었을 때 호출되는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectedDateStr = TimeManager.shared.dateToYearMonthDay(date: date)
        configureDiaryView(diaryDate: date)
    }
    
    // 캘린더에 표시되는 이벤트 갯수를 반환해주는 메서드
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
    func addDiary(_ diaryObj: Diary, photoList: [UIImage]?, diaryEditorMode: DiaryEditorMode) {
        if diaryEditorMode == .new {
            diaryList.append(diaryObj)
            registeredDiaryDateList.append(TimeManager.shared.dateToYearMonthDay(date: diaryObj.date))
            selectedDate = diaryObj.date
            configureDiaryView(diaryDate: selectedDate)
            calendarView.reloadData()
            guard let photoList = photoList else {
                registeredDiaryView.diaryImageView.image = UIImage(named: "SplashImage")
                return
            }
            registeredDiaryView.diaryImageView.image = photoList[0]
        } else if diaryEditorMode == edit {
            // MARK: - 일기장 수정 후 로직 구현
            
        }
    }
}

