//
//  PresenterSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 20.09.2023.
//

// MARK: - SubscriptionPresenterProtocol

protocol SubscriptionPresenterProtocol: AnyObject {
    
}

// MARK: - SubscriptionPresenter

final class SubscriptionPresenter {
    
    weak var viewController: SubscriptionViewControllerProtocol?
    
    //MARK: - PrivateProperties
    private let sceneBuildManager: Buildable

    //MARK: - Initialize
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

// MARK: - SubscriptionPresenterProtocol Imp
extension SubscriptionPresenter: SubscriptionPresenterProtocol {
    
}
