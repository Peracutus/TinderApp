//
//  ViewController.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let pinkView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        pinkView.backgroundColor = .systemPink
    
        setupLayout()
    }
    
    //MARK: - Fileprivate

    fileprivate func setupLayout() {
        let generalStack = UIStackView(arrangedSubviews: [topStackView, pinkView, buttonsStackView])
        generalStack.axis = .vertical
        
        view.addSubview(generalStack)
        
        generalStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

}

