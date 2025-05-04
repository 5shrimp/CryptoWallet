//
//  CurrencyCell.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 27.04.2025.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static let reuseId = "CurrencyCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bitcoin")
        return imageView
    }()
    
    let leftStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    let rightStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .trailing
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        return label
    }()
    
    let abbreviationLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .gray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "38 000 $"
        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        return label
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.text = "2.2 %"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrencyCell {
    func update(currency: Currency?) {
        nameLabel.text = currency?.name
        abbreviationLabel.text = currency?.symbol
        priceLabel.text = String(format: "$%.2f", currency?.marketData.volumeLast24Hours ?? 0.0)
        percentLabel.text = String(format: "%.2f", currency?.marketData.percent ?? 0.0)+"%"
        
    }
    
    func setupViews() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(leftStackView)
        self.contentView.addSubview(rightStackView)
        leftStackView.addArrangedSubview(nameLabel)
        leftStackView.addArrangedSubview(abbreviationLabel)
        rightStackView.addArrangedSubview(priceLabel)
        rightStackView.addArrangedSubview(percentLabel)
    }
    
    func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(25)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        leftStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(20)
        }
        rightStackView.snp.makeConstraints { make in
            make.right.equalTo(contentView).inset(25)
            make.centerY.equalToSuperview()
        }
    }
}
