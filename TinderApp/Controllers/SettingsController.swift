//
//  SettingsController.swift
//  TinderApp
//
//  Created by Roman on 29.11.2021.
//

import UIKit

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //instance properties
    lazy var headerImage1 = customButton(selector: #selector(handleSelectPhoto))
    lazy var headerImage2 = customButton(selector: #selector(handleSelectPhoto))
    lazy var headerImage3 = customButton(selector: #selector(handleSelectPhoto))
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedPhoto = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedPhoto?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
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
        
        setupNavigationItems()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.bounces = false
    }
    
    fileprivate func setupNavigationItems() {
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleCancel))
        
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
    
    class HeaderLabel: UILabel {
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
        
    }
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
        default:
            label.text = "Bio"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
        case 2:
            cell.textField.placeholder = "Enter profession"
        case 3:
            cell.textField.placeholder = "Enter age"
        default:
            cell.textField.placeholder = "Write BIO"
        }
        return cell
    }
    
    
    
}

