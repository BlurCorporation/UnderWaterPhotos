//
//  UIView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 06.09.2023.
//

import UIKit

extension UIView {
    func myAddSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            myAddSubview(view)
        }
    }
}

extension UIView {
    func pushAnimate(_ completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(
                    scaleX: 0.9,
                    y: 0.9
                )
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                } completion: { _ in
                    completion?()
                }
            })
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
