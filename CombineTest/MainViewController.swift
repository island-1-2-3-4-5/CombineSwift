//
//  ViewController.swift
//  CombineTest
//
//  Created by Роман on 06.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    
    //MARK: Values
    private let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    
    
    //MARK: Functions
    private func setViews() {
        view.addSubview(toggle)
        
    }
    
}

