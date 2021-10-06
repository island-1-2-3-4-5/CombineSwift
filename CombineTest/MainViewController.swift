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
        button.setTitleColor(#colorLiteral(red: 0.138754338, green: 0.604771018, blue: 0.9985782504, alpha: 1), for: .normal)
        return button
    }()
    
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = Constants.TextLabels.postLabel
        return label
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
                         makePostButton,
                         postLabel)
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
                           trailing: toggle.leadingAnchor,
                           padding: Constants.Paddings.titlleLabel)
        
        makePostButton.anchor(top: titlleLabel.bottomAnchor,
                              leading: titlleLabel.leadingAnchor,
                              bottom: nil,
                              trailing: nil, padding: Constants.Paddings.makePostButton)
        
        postLabel.anchor(top: makePostButton.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor, padding: Constants.Paddings.postLabel)
    }
    
}

