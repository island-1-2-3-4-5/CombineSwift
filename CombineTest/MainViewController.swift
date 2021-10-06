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
        return toggle
    }()
    
    private let titlleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = Constants.TextLabels.titlleLabel
        return label
    }()
    
    
    private let makePostButton: UIButton = {
        let button = UIButton()
        button.setTitle( Constants.TextLabels.makePostButton, for: .normal)
        return button
    }()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    
    
    //MARK: Functions
    private func setViews() {
        view.backgroundColor = .white
        view.addSubviews(toggle,
                         titlleLabel,
                         makePostButton)
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        toggle.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      leading: nil,
                      bottom: nil,
                      trailing: view.trailingAnchor,
                      padding: Constants.Paddings.toggleInserts)
        
        titlleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.leadingAnchor,
                           bottom: nil,
                           trailing: toggle.leadingAnchor, padding: Constants.Paddings.titlleLabel)
    }
    
}

