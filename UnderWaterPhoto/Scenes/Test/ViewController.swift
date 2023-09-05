//
//  ViewController.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {}

class ViewController: UIViewController {
    var presenter: PresenterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
    }


}

extension ViewController: ViewControllerProtocol {}
