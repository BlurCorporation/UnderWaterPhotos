//
//  PriceView.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 03.12.2023.
//

import Foundation
import SwiftUI

struct PriceView: View {
    var priceScroll: PriceScroll
    var body: some View {
        VStack {
            Text(priceScroll.title)
                .foregroundStyle(.white)
            Spacer()
            Text(priceScroll.price)
                .foregroundStyle(.white)
            Spacer()
            Text(priceScroll.priceForDay)
                .foregroundStyle(.white)
        }
        .frame(width: 136, height: 170)
//        .background(Color(.blueDark))
        .cornerRadius(20)
    }
}

struct ScrollPriceView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(priceData) { item in
                    PriceView(priceScroll: item)
                }
            }
            .padding(16)
        }
    }
}
