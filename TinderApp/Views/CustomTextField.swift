//
//  CustomTextField.swift
//  TinderApp
//
//  Created by Roman on 24.11.2021.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    
    init(padding: CGFloat, placeholder: String) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
        backgroundColor = .white
        self.placeholder = placeholder
    }
    
    // set padding from edges
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    //set height
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
