//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol PresenterProtocol: AnyObject {
    
}

class Presenter {
    weak var viewController: ViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

extension Presenter: PresenterProtocol {
    
}
