//
//  AuthViewController.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 18.09.2023.
//

import UIKit

// MARK: - ExampleViewControllerProtocol

protocol ExampleViewControllerProtocol: UIViewController {
    
}

// MARK: - ExampleViewController

final class ExampleViewController: UIViewController {
    
    var presenter: ExamplePresenterProtocol?
    
    // MARK: PrivateProperties
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    
    // MARK: Action
}

// MARK: - ExampleViewControllerProtocol Imp

extension ExampleViewController: ExampleViewControllerProtocol {
    
}

// MARK: - PrivateMethods

private extension ExampleViewController {
    func setupViewController() {
        addSubviews()
        setupConstraints()
        setupNavigationController()
    }
    
    func setupNavigationController() {
        
    }
    
    func addSubviews() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([])
    }
}

