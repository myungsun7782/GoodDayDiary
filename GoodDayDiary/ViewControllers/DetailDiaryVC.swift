//
//  DetailDiaryVC.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit
import BSImagePicker
import Photos

class DetailDiaryVC: UIViewController {
    // UILabel
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // UITableView
    @IBOutlet weak var diaryTableView: UITableView!
    
    // UICollectionView
    var photoCollectionView: UICollectionView?
    
    // Variables
    var photoList = Array<UIImage>()
    
    // Constants
    let SECTION_COUNT: Int = 1
    let TABLE_VIEW_NUMBER_OF_SECTIONS: Int = 4
    let COLLECTION_VIEW_NUMBER_OF_SECTIONS: Int = 2
    let NUM_PHOTO_MAX = 5
    let CONTENTS_PLACE_HOLDER = "당신의 소중한 하루를 기록해주세요 :)"
    let TITLE_FONT_SIZE: CGFloat = 20
    let BUTTON_FONT_SIZE: CGFloat = 18
    let BUTTON_BORDER_RADIUS: CGFloat = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //        print("\(diaryTableView.frame.height)")
    }
    
    private func initUI() {
        configureLabels()
        configureTableView()
        configureButton()
    }
    
    private func configureTableView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        diaryTableView.addGestureRecognizer(tapGesture)
        diaryTableView.keyboardDismissMode = .onDrag
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        diaryTableView.register(UINib(nibName: "DiaryDateCell", bundle: nil), forCellReuseIdentifier: "DiaryDateCell")
        diaryTableView.register(UINib(nibName: "DiaryPlaceCell", bundle: nil), forCellReuseIdentifier: "DiaryPlaceCell")
        diaryTableView.register(UINib(nibName: "DiaryPhotoCell", bundle: nil), forCellReuseIdentifier: "DiaryPhotoCell")
        diaryTableView.register(UINib(nibName: "DiaryContentCell", bundle: nil), forCellReuseIdentifier: "DiaryContentCell")
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
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
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
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
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPlaceCell", for: indexPath) as! DiaryPlaceCell
            
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryPhotoCell", for: indexPath) as! DiaryPhotoCell
            
            photoCollectionView = cell.photoCollectionView
            cell.selectionStyle = .none
            cell.photoCollectionView.delegate = self
            cell.photoCollectionView.dataSource = self
            cell.photoCollectionView.register(UINib(nibName: "AddPhotoCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoCell")
            cell.photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
            
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryContentCell", for: indexPath) as! DiaryContentCell
            
            cell.selectionStyle = .none
            cell.contentTextView.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TABLE_VIEW_NUMBER_OF_SECTIONS
    }
}

// UICollectionView
extension DetailDiaryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return COLLECTION_VIEW_NUMBER_OF_SECTIONS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return photoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = photoList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(tapDeleteButton(button:)), for: .touchUpInside)
        return cell
    }
    
    @objc private func tapDeleteButton(button: UIButton) {
        let index = button.tag
        photoList.remove(at: index)
        photoCollectionView!.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if photoList.count == NUM_PHOTO_MAX {
                // TODO: Show alert
                let alert = UIAlertController(title: nil, message: "사진은 최대 5장까지 등록할 수 있습니다.", preferredStyle: .alert)
                let confirmButton = UIAlertAction(title: "확인", style: .default)
                alert.addAction(confirmButton)
                present(alert, animated: true, completion: nil)
                return
            }
            
            let imagePicker = ImagePickerController()
            imagePicker.overrideUserInterfaceStyle = .light
            imagePicker.settings.selection.max = self.NUM_PHOTO_MAX-self.photoList.count
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.theme.selectionFillColor = ColorManager.shared.getBlue()
            imagePicker.settings.theme.selectionStrokeColor = .white
            imagePicker.doneButton.tintColor = ColorManager.shared.getBlue()
            imagePicker.cancelButton.tintColor = .red
            
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
            }, cancel: { (assets) in
            }, finish: { (assets) in
                for asset in assets {
                    let image = self.getAssetThumbnail(asset: asset)
                    self.photoList.append(image)
                }
                self.photoCollectionView!.reloadData()
            })
        } else { // 사진 목록 section
            let detailImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailImageVC") as! DetailImageVC
            
            detailImageVC.detailImage = photoList[indexPath.row]
            detailImageVC.modalTransitionStyle = .crossDissolve
            detailImageVC.modalPresentationStyle = .overFullScreen
            present(detailImageVC, animated: true)
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
}

// UITextView
extension DetailDiaryVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == CONTENTS_PLACE_HOLDER {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = CONTENTS_PLACE_HOLDER
            textView.textColor = ColorManager.shared.getLightGray()
        }
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //        validateInputField()
    //    }
}

