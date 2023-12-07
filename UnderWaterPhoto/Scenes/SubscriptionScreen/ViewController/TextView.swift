//
//  TextView.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 03.12.2023.
//

import Foundation
import SwiftUI

struct TextView: View {
    @State private var rulesText = "Oформляя подписку вы соглашаетесь на Условия использования и Политику конфиденциальности"
    
    var attributedString: AttributedString {
        var attrS = AttributedString(rulesText)
        let range = attrS.range(of: "Условия использования и Политику конфиденциальности")!
        
        attrS[range].foregroundColor = .blue
        
        return attrS
    }
    
    var body: some View {
        Text(attributedString)
            .foregroundColor(.white)
            .font(.callout)
    }
}
