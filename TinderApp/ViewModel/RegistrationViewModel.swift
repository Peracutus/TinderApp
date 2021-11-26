//
//  RegistrationHandleViewModel.swift
//  TinderApp
//
//  Created by Roman on 25.11.2021.
//

import UIKit
//Reactive programming
class RegistrationViewModel {
    
    var fullName: String? { didSet { chechFormValidity() } }
    var email: String? { didSet { chechFormValidity() } }
    var password: String? { didSet { chechFormValidity() } }
    
    fileprivate func chechFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        isFormValidObserver?(isFormValid)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
}

