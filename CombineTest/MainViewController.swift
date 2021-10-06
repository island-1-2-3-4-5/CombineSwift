//
//  ViewController.swift
//  CombineTest
//
//  Created by Роман on 06.10.2021.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //MARK: Properties
    @Published var canMakePost: Bool = false
    private var switchSubscriber: AnyCancellable?
    
    //MARK: UI
    private let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleAction), for: .valueChanged)
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
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setPublisher()
    }
    
    
    
    //MARK: Functions
    
    private func setPublisher() {
        switchSubscriber = $canMakePost.receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: makePostButton)
    }
    
    
    private func setViews() {
        view.backgroundColor = .white
        view.addSubviews(
            toggle,
            titlleLabel,
            makePostButton,
            postLabel
        )
        
        layoutViews()
    }
    
    
    fileprivate func layoutViews() {
        toggle.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: Constants.Paddings.toggleInserts
        )
        
        titlleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: toggle.leadingAnchor,
            padding: Constants.Paddings.titlleLabel
        )
        
        makePostButton.anchor(
            top: titlleLabel.bottomAnchor,
            leading: titlleLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: Constants.Paddings.makePostButton
        )
        
        postLabel.anchor(
            top: makePostButton.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: Constants.Paddings.postLabel
        )
    }
    
    
    //MARK: - Actions
    @objc func toggleAction(_ sender: UISwitch) {
        canMakePost = sender.isOn
        print(canMakePost)
    }
    
    
    @objc func buttonAction(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }
    
}

