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
    var photoList = Array<UIImage>()
    
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
    
    func setData(detailDiaryVC: DetailDiaryVC, photoList: Array<UIImage>) {
        self.detailDiaryVC = detailDiaryVC
        self.photoList = photoList
        photoCollectionView.reloadData()
    }
}

extension DiaryPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return COLLECTION_VIEW_NUMBER_OF_SECTIONS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = photoList[indexPath.row]
        cell.deleteButton.rx.tap
            .subscribe(onNext: { _ in
                if let detailDiaryVC = self.detailDiaryVC {
                    detailDiaryVC.photoList.remove(at: indexPath.row)
                }
                
                self.photoList.remove(at: indexPath.row)
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
                if photoList.count == NUM_PHOTO_MAX {
                    detailDiaryVC.presentPhotoMaxAlert()
                } else {
                    detailDiaryVC.presentImagePicker(numPhotoMax: NUM_PHOTO_MAX)
                }
            } else { // 사진 목록 section
                detailDiaryVC.presentDetailImageVC(detailImage: photoList[indexPath.row])
            }
        }
    }
}

