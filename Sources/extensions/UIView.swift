//
//  UIView.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 01/10/2022.
//

import UIKit

extension UIView {
    func addingShadow(
        offset: CGSize = CGSize(width: 0.0, height: 2.0),
        radius: CGFloat = 6.0,
        opacity: Float = 0.12
    ) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func roundUpperCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
