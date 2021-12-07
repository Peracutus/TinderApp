//
//  SettingsController.swift
//  TinderApp
//
//  Created by Roman on 29.11.2021.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: SettingsControllerDelegate?
    
    //instance properties
    lazy var headerImage1 = customButton(selector: #selector(handleSelectPhoto))
    lazy var headerImage2 = customButton(selector: #selector(handleSelectPhoto))
    lazy var headerImage3 = customButton(selector: #selector(handleSelectPhoto))
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedPhoto = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedPhoto?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedPhoto?.jpegData(compressionQuality: 0.75) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving image"
        hud.show(in: view)
        
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storage", err)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL { (url, err) in
                hud.dismiss()
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("Finished getting download url:", url?.absoluteString ?? "")
                if imageButton == self.headerImage1 {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.headerImage2 {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
    
    //MARK: - Views
    
    fileprivate func customButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.tintColor = .black
        button.layer.borderWidth = 1
        return button
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItems()
        fetchCurrentUser()
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user", error)
                return
            }
            self.user = user
            self.loadUserPhoto()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhoto() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.headerImage1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.headerImage2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.headerImage3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func setupNavigationItems() {
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleCancel)),
                                              UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))]
    }
    
    //MARK: - UITableView
    
    fileprivate func setupTableView() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.bounces = false
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 20
    }
    
    lazy var header: UIView = {
        
        let header = UIView()
        header.addSubview(headerImage1)
        let padding: CGFloat = 16
        headerImage1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        headerImage1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let vStackView = UIStackView(arrangedSubviews: [headerImage2, headerImage3])
        vStackView.axis = .vertical
        vStackView.spacing = padding
        vStackView.distribution = .fillEqually
        
        header.addSubview(vStackView)
        vStackView.anchor(top: header.topAnchor, leading: headerImage1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let label = HeaderLabel()
        switch section {
        case 1:
            label.text = "Name"
        case 2:
            label.text = "Profession"
        case 3:
            label.text = "Age"
        case 4:
            label.text = "Bio"
        default:
            label.text = "Seeking age range"
        }
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRange = AgeRangeTableCell(style: .default, reuseIdentifier: nil)
            ageRange.minAgeSlider.addTarget(self, action: #selector(changeMinAgeSlider), for: .valueChanged)
            ageRange.maxAgeSlider.addTarget(self, action: #selector(handleMaxAgeSlider), for: .valueChanged)
            ageRange.minLabel.text = "Min: \(user?.minSearchAge ?? 18)"
            ageRange.minAgeSlider.value = Float(user?.minSearchAge ?? 18)
            ageRange.maxLabel.text = "Max: \(user?.maxSearchAge ?? 55)"
            ageRange.maxAgeSlider.value = Float(user?.maxSearchAge ?? 40)
            return ageRange
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Write BIO"
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        }
        return cell
    }
    
    fileprivate func evaluateMinMax() {
        guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeTableCell else { return }
        let minValue = Int(ageRangeCell.minAgeSlider.value)
        var maxValue = Int(ageRangeCell.maxAgeSlider.value)
        maxValue = max(minValue, maxValue)
        ageRangeCell.maxAgeSlider.value = Float(maxValue)
        ageRangeCell.minLabel.text = "Min \(minValue)"
        ageRangeCell.maxLabel.text = "Max \(maxValue)"
        
        user?.minSearchAge = minValue
        user?.maxSearchAge = maxValue
    }
    
    //MARK: - Selectors
    
    @objc fileprivate func changeMinAgeSlider(slider: UISlider) {
        evaluateMinMax()
    }
    
    @objc fileprivate func handleMaxAgeSlider(slider: UISlider) {
        evaluateMinMax()
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleBioChange(textField: UITextField) {
        self.user?.bio = textField.text
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String : Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "age": user?.age ??  -1,
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "profession": user?.profession ?? "",
            "bio": user?.bio ?? "",
            "minAgeValue": user?.minSearchAge ?? 18,
            "maxAgeValue": user?.maxSearchAge ?? 55
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            hud.dismiss()
            if let err = err {
                print(err)
                return
            }
            print("Finished saving user info")
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    //MARK: - Inner class
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
        
    }
}

