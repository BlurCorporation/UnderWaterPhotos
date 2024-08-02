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
	PriceScroll(title: L10n.SubscriptionModel.PriceData.FirstElement.title, price: L10n.SubscriptionModel.PriceData.FirstElement.price, priceForDay: L10n.SubscriptionModel.PriceData.FirstElement.priceForDay, Color: Color.purple),
	PriceScroll(title: L10n.SubscriptionModel.PriceData.SecondElement.title, price: L10n.SubscriptionModel.PriceData.SecondElement.price, priceForDay: L10n.SubscriptionModel.PriceData.SecondElement.priceForDay, Color: Color.purple),
	PriceScroll(title: L10n.SubscriptionModel.PriceData.ThirdElement.title, price: L10n.SubscriptionModel.PriceData.ThirdElement.price, priceForDay: L10n.SubscriptionModel.PriceData.ThirdElement.priceForDay, Color: Color.purple),
	PriceScroll(title: L10n.SubscriptionModel.PriceData.FourthElement.title, price: L10n.SubscriptionModel.PriceData.FourthElement.price, priceForDay: L10n.SubscriptionModel.PriceData.FourthElement.priceForDay, Color: Color.purple)
]


