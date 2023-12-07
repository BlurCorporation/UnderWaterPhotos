//
//  ModelSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 19.10.2023.
//

import Foundation
import SwiftUI

struct SubscriptionModel {

}

/// Модель данных скролла цен на подписки
struct PriceScroll: Identifiable {
    var id = UUID()
    var title: String
    var price: String
    var priceForDay: String
    var Color: Color
}

/// Название, цена, цена за 1 день подписки
let priceData = [
    PriceScroll(title: "Первая подписка", price: "9 миллинов", priceForDay: "300 тыщ", Color: Color.purple),
    PriceScroll(title: "Вторая подписка", price: "16 рублей", priceForDay: "3 копейки", Color: Color.purple),
    PriceScroll(title: "Третья крутая подписка", price: "3 конфетки", priceForDay: "4 нюдса", Color: Color.purple),
    PriceScroll(title: "Четвертая подписка", price: "какая-нибудь цена", priceForDay: "не смотреть рилсы", Color: Color.purple)
]


