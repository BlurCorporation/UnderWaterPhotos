//
//  CastomButton.swift
//  UnderWaterPhoto
//
//  Created by Антон on 23.10.2023.
//

import UIKit

enum TypeButton {
    case registrationButton
    case idBitton
    case loginButton
}

final class CastomButton: UIButton {
    var type: TypeButton? {
        didSet {
            if let type = type {
                setupButton(type: type)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupButton(type: TypeButton) {
        switch type {
        case .registrationButton:
            layer.cornerRadius = 16
            backgroundColor = UIColor(named: "backgroundColorRegistrationButton")
            setTitleColor(UIColor(named: "backgroundColorRegistrationTitle"), for: .normal)
        case .idBitton:
            layer.cornerRadius = 14
            backgroundColor = UIColor(named: "backgroundColorIdButton")
        case .loginButton:
            setTitleColor(UIColor(named: "backgroundColorRegistrationButton"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
