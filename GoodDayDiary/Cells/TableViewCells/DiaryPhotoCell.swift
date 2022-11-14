//
//  DiaryPhotoCell.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit
import RxCocoa
import RxSwift

class DiaryPhotoCell: UITableViewCell {
    // UIViewController
    var detailDiaryVC: DetailDiaryVC?
    
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UICollectionView
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // Variables
    var photoList: Array<UIImage>?
    var photoIdList: Array<String>?
    var diaryEditorMode: DiaryEditorMode!
    
    // Constants
    let TITLE_FONT_SIZE: CGFloat = 20
    let COLLECTION_VIEW_NUMBER_OF_SECTIONS: Int = 2
    let NUM_PHOTO_MAX = 5
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureLabel()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "AddPhotoCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoCell")
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func configureLabel() {
        titleLabel.font = FontManager.shared.getAppleSDGothicNeoBold(fontSize: TITLE_FONT_SIZE)
    }
    
    func setData(diaryEditorMode: DiaryEditorMode, detailDiaryVC: DetailDiaryVC, photoList: Array<UIImage>?, photoIdList: Array<String>?) {
        self.diaryEditorMode = diaryEditorMode // 값이 무조건 넘어온다. (.new or .edit)
        self.detailDiaryVC = detailDiaryVC
        
        self.photoList = photoList
        self.photoIdList = photoIdList
        
        photoCollectionView.reloadData()
    }
}

extension DiaryPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return COLLECTION_VIEW_NUMBER_OF_SECTIONS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if diaryEditorMode == .new {
                guard let photoList = photoList else { return 0 }
                return photoList.count
            }
            
            // diaryEditorMode == .edit
            guard let photoIdList = photoIdList else {
                if !photoList!.isEmpty {
                    return photoList!.count
                }
                return 0
            }
            return photoIdList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if diaryEditorMode == .new {
            cell.photoImageView.image = photoList![indexPath.row]
        } else if diaryEditorMode == .edit {
            print("edit called")
            if !photoList!.isEmpty {
                print("photoList is not Empty")
                cell.photoImageView.image = photoList![indexPath.row]
            } else {
                print("PhotoList is Empty")
                cell.photoImageView.fetchImage(photoId: photoIdList![indexPath.row])
            }
        }
        
        cell.deleteButton.rx.tap
            .subscribe(onNext: { _ in
                if self.diaryEditorMode == .new {
                    self.photoList?.remove(at: indexPath.row)
                    if let detailDiaryVC = self.detailDiaryVC {
                        detailDiaryVC.photoList.remove(at: indexPath.row)
                    }
                } else if self.diaryEditorMode == .edit {
                    // .edit 상태일 때 photo를 등록하지 않은 상태여서 다시 등록하는 경우
                    if !self.photoList!.isEmpty {
                        self.photoList?.remove(at: indexPath.row)
                        if let detailDiaryVC = self.detailDiaryVC {
                            detailDiaryVC.photoList.remove(at: indexPath.row)
                        }
                    } else {
                        self.photoIdList?.remove(at: indexPath.row)
                    }
                }

                self.photoCollectionView!.reloadData()
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: section == 0 ? 24 : 0,
                            bottom: 0,
                            right: section == 0 ? 0 : 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailDiaryVC = detailDiaryVC {
            if indexPath.section == 0 {
                if let photoList = photoList {
                    if photoList.count == NUM_PHOTO_MAX {
                        detailDiaryVC.presentPhotoMaxAlert()
                    } else {
                        detailDiaryVC.presentImagePicker(numPhotoMax: NUM_PHOTO_MAX)
                    }
                }
            } else { // 사진 목록 section
                if diaryEditorMode == .new {
                    if let photoList = photoList {
                        detailDiaryVC.presentDetailImageVC(detailImage: photoList[indexPath.row])
                    }
                } else if diaryEditorMode == .edit {
                    if let photoIdList = photoIdList {
                        detailDiaryVC.presentDetailImageVC(photoId: photoIdList[indexPath.row])
                    }
                }
            }
        }
    }
}

