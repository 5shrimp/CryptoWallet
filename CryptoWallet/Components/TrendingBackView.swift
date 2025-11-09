//
//  TrendingBackView.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 27.04.2025.
//

import UIKit
import SnapKit

final class TrendingBackView: UIView {
    weak var delegate: TrendingBackViewDelegate?
    private var currencyList: [Currency] = []
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return label
    }()
    
    private let sortingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Search icon"), for: .normal)
        button.addTarget(nil, action: #selector(sortingButtonTapped), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currencyList: [Currency]) {
        self.currencyList = currencyList
        tableView.reloadData()
    }
}

protocol TrendingBackViewDelegate: AnyObject {
    func didTapCell(currency: Currency)
}

extension TrendingBackView {
    private func setupStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
    }
    
    private func setupViews() {
        self.addSubview(titleLabel)
        self.addSubview(sortingButton)
        self.addSubview(tableView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(30)
        }
        
        sortingButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.bottom.equalToSuperview()
            make.right.left.equalToSuperview()
        }
    }
    
    @objc func sortingButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        print("Текущее состояние: \(sender.isSelected ? "Включено" : "Выключено")")
        sortAsc(sender.isSelected)
    }
    
    private func sortAsc(_ bool: Bool) {
        let sortedCurrencies = self.currencyList.sorted {
            if bool {
                $0.marketData.volumeLast24Hours > $1.marketData.volumeLast24Hours
            } else {
                $0.marketData.volumeLast24Hours < $1.marketData.volumeLast24Hours
            }
        }
        self.currencyList = sortedCurrencies
        tableView.reloadData()
    }
}

extension TrendingBackView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCell(currency: self.currencyList[indexPath.row])
    }
}

extension TrendingBackView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.update(currency: self.currencyList[indexPath.row])
        return cell
    }
    
    
}


