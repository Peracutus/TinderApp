//
//  RegistrationHandleViewModel.swift
//  TinderApp
//
//  Created by Roman on 25.11.2021.
//

import UIKit
import Firebase

//Reactive programming
class RegistrationViewModel {
    
    var bindableRegistrering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? { didSet { chechFormValidity() } }
    var email: String? { didSet { chechFormValidity() } }
    var password: String? { didSet { chechFormValidity() } }
    
    fileprivate func chechFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else { return }
        bindableRegistrering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (res, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Successfully regitered user:", res?.user.uid ?? "" )
            
            //upload images to Firebase storage once you are authorized
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            
            ref.putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                print("Finished uploading image to storage")
                ref.downloadURL { (url, err) in
                    if let err = err {
                        completion(err)
                        return
                    }
                    
                    self.bindableRegistrering.value = false
                    print("Download url of our image is:", url?.absoluteString ?? "")
                }
            }
        }
    }
}

