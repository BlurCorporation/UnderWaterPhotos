//
//  AuthPresenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 18.09.2023.
//

// MARK: - ExamplePresenterProtocol

protocol ExamplePresenterProtocol: AnyObject {
    
}

// MARK: - ExamplePresenter

final class ExamplePresenter {
    
    weak var viewController: ExampleViewControllerProtocol?
    
    //MARK: - PrivateProperties
    private let sceneBuildManager: Buildable

    //MARK: - Initialize
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

// MARK: - ExamplePresenterProtocol Imp
extension ExamplePresenter: ExamplePresenterProtocol {
    
}
