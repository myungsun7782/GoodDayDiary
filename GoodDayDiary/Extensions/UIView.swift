//
//  UIView.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/27.
//

import UIKit

extension UIView {
    func makeViewGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        let colors: [CGColor] = [
            ColorManager.shared.getBlue().cgColor,
            ColorManager.shared.getVodka().cgColor
        ]
        let START_POINT_X: CGFloat = 0.0
        let START_POINT_Y: CGFloat = 0.0
        let END_POINT_X: CGFloat = 1.0
        let END_POINT_Y: CGFloat = 1.0
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: START_POINT_X, y: START_POINT_Y)
        gradientLayer.endPoint = CGPoint(x: END_POINT_X, y: END_POINT_Y)
        gradientLayer.cornerRadius = view.frame.width / 2
        
        view.layer.addSublayer(gradientLayer)
        view.layer.cornerRadius = view.frame.height / 2
    }
}
