//
//  ViewController.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit
import Firebase

class MainController: UIViewController {
    
    //MARK: - Views

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//            User(name: "Girl2", age: 20, profession: "Teacher", imageNames: ["girl_2"]),
//            User(name: "Alexandra", age: 23, profession: "Actress", imageNames: ["alexa_1", "alexa_2", "alexa_3"]),
//            Advertiser(title: "AdView", brandName: "Company", posterPhotoName: "adsView")
//        ] as [ProducesCardViewModel]

//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    var cardViewModels = [CardViewModel]()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupDummyCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
        //navigationController?.pushViewController(registrationController, animated: true)
    }
    
    //MARK: - Fileprivate
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                
            })
            self.setupDummyCards()
        }
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let generalStack = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        view.addSubview(generalStack)
        generalStack.axis = .vertical
        generalStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        generalStack.isLayoutMarginsRelativeArrangement = true
        generalStack.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        generalStack.bringSubviewToFront(cardsDeckView) 
    }

}

