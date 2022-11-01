//
//  DetailImageVC.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/31.
//

import UIKit

class DetailImageVC: UIViewController {
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // UIImageView
    @IBOutlet weak var detailImageView: UIImageView!
    
    // UIImage
    var detailImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapContainerView)))
        
        UIView.transition(with: detailImageView,
                          duration: 2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.detailImageView.image = self.detailImage
        })
    }
    
    @objc private func tapContainerView(_: UIView) {
        self.dismiss(animated: true)
    }
}
