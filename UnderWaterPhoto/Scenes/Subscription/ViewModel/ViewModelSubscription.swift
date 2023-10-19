//
//  PresenterSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 20.09.2023.
//

import Combine

// MARK: - SubscriptionViewModel

final class SubscriptionViewModel: ObservableObject {
    
    @Published private var subscriptionModel: SubscriptionModel
    
    init(subscriptionModel: SubscriptionModel = SubscriptionModel()) {
        self.subscriptionModel = subscriptionModel
    }
}
