//
//  LanguageSettingPresenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 13.11.2023.
//

import Foundation

protocol LanguageSettingPresenterProtocol: AnyObject {
    func backButtonPressed()
}

final class LanguageSettingPresenter {
    weak var viewController:  LanguageSettingViewController?
    private let sceneBuildManager: Buildable
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

extension LanguageSettingPresenter: LanguageSettingPresenterProtocol {
    func backButtonPressed() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
