//
//  RegistrationCell.swift
//  TinderApp
//
//  Created by Roman on 29.11.2021.
//

import UIKit

class RegistrationCell: UITableViewCell {

    static let reuseId = "registrationCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
