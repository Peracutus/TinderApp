//
//  ViewController.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit
import Firebase
import JGProgressHUD

class MainController: UIViewController {
    
    //MARK: - Views

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefreshButton() {
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleSettings() {
        
        let settings = SettingsController()
        let navigation = UINavigationController(rootViewController: settings)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
        
//        let registrationController = RegistrationController()
//        present(registrationController, animated: true)
    }
    
    //MARK: - Fileprivate
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                
                self.setupCardFromUser(user: user)
            })
            //elf.setupDummyCards()
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        //cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
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
        let generalStack = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        view.addSubview(generalStack)
        generalStack.axis = .vertical
        generalStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        generalStack.isLayoutMarginsRelativeArrangement = true
        generalStack.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        generalStack.bringSubviewToFront(cardsDeckView) 
    }

}

