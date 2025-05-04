//
//  TextEditForm.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 27.04.2025.
//

import UIKit
import SnapKit

class TextEditForm: UIView {
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Poppins-Regular", size: 18)
        return textField
    }()
    
    init(_ imageName: String, _ text: String) {
        super.init(frame: .zero)
        
        update(imageName: imageName, placeholder: text)
        setupViews()
        setupConstraints()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(imageName: String, placeholder: String) {
        imageView.image = UIImage(named: imageName)
        textField.placeholder = placeholder
    }
}

extension TextEditForm {
    func setupStyle() {
        self.layer.cornerRadius = 25
        self.backgroundColor = .white
    }
    
    func setupViews() {
        self.addSubview(imageView)
        self.addSubview(textField)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {make in 
            make.left.equalTo(self).offset(10)
            make.height.width.equalTo(30)
            make.centerY.equalTo(self)
        }
        textField.snp.makeConstraints {make in
            make.top.right.bottom.equalTo(self).offset(0)
            make.height.equalTo(55)
            make.left.equalTo(imageView.snp.right).offset(20)
        }
    }
}

