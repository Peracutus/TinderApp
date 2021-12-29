//
//  ViewController.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit
import Firebase
import JGProgressHUD

class MainController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {

    
    //MARK: - Views
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchFilteredUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {

            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navigationController = UINavigationController(rootViewController: registrationController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
        view.reloadInputViews()
    }
    
    func didFinishLoggingIn() {
        fetchFilteredUser()
    }
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    fileprivate func fetchFilteredUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }
    
    //MARK: - Fileprivate
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        guard let minAge = user?.minSearchAge, let maxAge = user?.maxSearchAge else { return }
        
        let ageFilterQuery = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        
        ageFilterQuery.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo() {
        print("delegate work")
        let userDetailsController = UserDetailsViewController()
        present(userDetailsController, animated: true, completion: nil)
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
    
    //MARK: - Selectors
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleSettings() {
        let settings = SettingsController()
        let navigation = UINavigationController(rootViewController: settings)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    //MARK: - Delegate protocol
    
    func didSaveSettings() {
        print("Notified of dismissal from SettingsController in HomeController")
        fetchFilteredUser()
    }
    
}

