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
        button.backgroundColor = .green
        button.setTitle("select photo", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        //        tableView.delegate = self
        //        tableView.dataSource = self
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //
    }
    
    fileprivate func setupNavigationItems() {
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleCancel))
        
    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 5
    //    }
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 50
    //    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .red
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
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //
    //        return cell
    //    }
    //
    
  
}

