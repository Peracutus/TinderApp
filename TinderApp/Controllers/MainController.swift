//
//  ViewController.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class MainController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    let cardViewModels = [
        User(name: "Girl2", age: 20, profession: "Teacher", imageName: "girl_2").toCardViewModel(),
        User(name: "Alexandra", age: 23, profession: "Actress", imageName: "girl_1").toCardViewModel()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
        setupDummyCards()
    }
    
    //MARK: - Fileprivate
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.infoLabel.attributedText = cardVM.attributedString
            cardView.infoLabel.textAlignment = cardVM.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    fileprivate func setupLayout() {
        let generalStack = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        view.addSubview(generalStack)
        generalStack.axis = .vertical
        generalStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        generalStack.isLayoutMarginsRelativeArrangement = true
        generalStack.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        generalStack.bringSubviewToFront(cardsDeckView) 
    }

}

