//
//  ButtonView.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 03.12.2023.
//

import Foundation
import SwiftUI

struct ButtonView: View {
    var body: some View {
        Button(action: {
            // action
        }) {
            Text(L10n.ButtonView.title)
                .frame(maxWidth: 378, maxHeight: 155)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(16)
        }
    }
}
