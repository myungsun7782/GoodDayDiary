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
    
    private func initUI() {
        configureLabels()
        configureCalendarView()
//        configureUnregisteredDiaryView()
        configureRegisteredDiaryView()
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
}

extension MainVC: FSCalendarDataSource, FSCalendarDelegate {
    // 캘린더에서 날짜가 선택되었을 때 호출되는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    // 캘린더에 표시되는 이벤트 갯수를 반환해주는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}

