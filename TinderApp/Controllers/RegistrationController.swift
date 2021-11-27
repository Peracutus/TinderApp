//
//  RegistrationController.swift
//  TinderApp
//
//  Created by Roman on 24.11.2021.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseStorage

class RegistrationController: UIViewController {
    
    //MARK: - Views
    
    let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selecte Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 270).isActive = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    let nameTextField = CustomTextField(padding: 24, placeholder: "Enter full name")
    let emailTextField = CustomTextField(padding: 24, placeholder: "Enter email")
    let passwordTextField = CustomTextField(padding: 24, placeholder: "Enter password")
    
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = .systemGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            registrationButton])
        sv.spacing = 10
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [selectImageButton,
                                                        verticalStackView])
    
    //MARK: - App lifeCycle
    let registeringHUD = JGProgressHUD(style: .dark)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) //you will have a retain cycle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        setupTapGesture()
        setupNatificationObserver()
        setupRegistrationViewModelObserver()
    }
     
    //MARK: - Fileprivate
    fileprivate let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        
        stackView.axis = .vertical
        selectImageButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        passwordTextField.isSecureTextEntry = true
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc fileprivate func handleVarifiedEmptyField( textField: UITextField) {
        
        if textField == nameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    fileprivate func setupNatificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupRegistrationViewModelObserver() {
        nameTextField.addTarget(self, action: #selector(handleVarifiedEmptyField), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleVarifiedEmptyField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleVarifiedEmptyField), for: .editingChanged)
        
        
        //FORM VALID
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            
            guard let isFormValid = isFormValid else { return }

            self.registrationButton.isEnabled = isFormValid
            
            if isFormValid {
                self.registrationButton.backgroundColor = UIColor.init(red: 1, green: 170/255, blue: 0, alpha: 1)
                self.registrationButton.setTitleColor(.white, for: .normal)
            } else {
                self.registrationButton.backgroundColor = .systemGray
                self.registrationButton.setTitleColor(.black, for: .normal)
            }
        }
        
        //IMAGE
        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.selectImageButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        //REGISTERING
        registrationViewModel.bindableRegistrering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
                self.emailTextField.text?.removeAll()
                self.passwordTextField.text?.removeAll()
                self.nameTextField.text?.removeAll()
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc fileprivate func handleSelectImage() {
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true)
        imagePicker.delegate = self
    }
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        
        registrationViewModel.performRegistration { (err) in
            if let err = err {
            self.showHudWithError(error: err)
            return
            }
            print("Finoshed registering user")
        }
    }
    
    fileprivate func showHudWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }

    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismisses keyboard
       
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // how tall the keyboard actually is? the code can find in google
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        
        //How to figure out how tall the gap is from register button to the bottom of the screen??
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
        //MARK: - create gradient layer with rotation changing
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor = UIColor.orange
        let bottomColor = UIColor.red
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
