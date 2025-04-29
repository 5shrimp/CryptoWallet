//
//  RefreshView.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 28.04.2025.
//

import UIKit
import SnapKit


class RefreshView: UIView {
    
    var delegate: RefreshViewDelegate?
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    private let refreshButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Oбновить"
        config.image = UIImage(named: "rocket")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    private let exitButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Выйти"
        config.image = UIImage(named: "trash")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RefreshView {
    func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.addSubview(stackView)
        stackView.addArrangedSubview(refreshButton)
        stackView.addArrangedSubview(exitButton)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func refreshButtonTapped() {
        self.delegate?.refreshButtonTapped()
    }
    
    @objc func exitButtonTapped() {
        self.delegate?.exitButtonTapped()
    }
}

protocol RefreshViewDelegate {
    func refreshButtonTapped()
    func exitButtonTapped()
}
