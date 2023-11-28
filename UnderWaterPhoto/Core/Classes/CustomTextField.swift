//
//  CustomTextField.swift
//  UnderWaterPhoto
//
//  Created by Антон on 23.10.2023.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = UIColor(named: "backgroundColorIdButton")
        attributedPlaceholder = placeholderText
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 11,
                               left: 16,
                               bottom: 11,
                               right: 0)
    let placeholderText = NSAttributedString(string: "text", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "backgroundColorTextField") as Any])
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

