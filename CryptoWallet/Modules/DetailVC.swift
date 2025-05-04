//
//  DetailVC.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 28.04.2025.
//

import UIKit
import SnapKit

protocol DetailViewProtocol: AnyObject {
    func displayTitle(_ title: String)
    func displayPrice(_ price: String)
    func displayPercent(_ percent: String)
    func displayCapitalization(_ cap: String)
    func displayCirculating(_ circulating: String)
}

class DetailVC: UIViewController, DetailViewProtocol {
    lazy var presenter: DetailPresenterProtocol = DetailPresenter(view: self, currency: self.currency)
    var currency: Currency = Currency(name: "", symbol: "", marketData: MarketData.init(volumeLast24Hours: 0.0, percent: 0.0), marketCapitalization: MarketCapitalization.init(capitalization: 0.0), supply: Supply(circulating: 0.0))

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 28)
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .gray
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["24H", "1W", "1Y", "ALL", "Point"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let statisticView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let statisticTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Statistic"
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return label
    }()
    
    private let capitalizationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market capitalization"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .gray
        return label
    }()
    
    private let circulatingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Circulating Suply"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .gray
        return label
    }()
    
    private let capitalizationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 14)
        return label
    }()
    
    private let circulatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 14)
        return label
    }()
    
    private let statisticLeftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let statisticRightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCustomBackButton()
        presenter.viewDidLoad()
    }
    
    // MARK: - DetailViewProtocol

    func displayTitle(_ title: String) {
        self.title = title
    }

    func displayPrice(_ price: String) {
        priceLabel.text = price
    }

    func displayPercent(_ percent: String) {
        percentLabel.text = percent
    }

    func displayCapitalization(_ cap: String) {
        capitalizationLabel.text = cap
    }

    func displayCirculating(_ circulating: String) {
        circulatingLabel.text = circulating
    }

    // MARK: - UI Setup

    private func setupViews() {
        view.backgroundColor = UIColor(red: 243/255, green: 245/255, blue: 246/255, alpha: 1.0)
        view.addSubview(priceLabel)
        view.addSubview(percentLabel)
        view.addSubview(segmentedControl)
        view.addSubview(statisticView)
        
        statisticView.addSubview(statisticLeftStackView)
        statisticView.addSubview(statisticRightStackView)
        
        statisticLeftStackView.addArrangedSubview(statisticTitleLabel)
        statisticLeftStackView.addArrangedSubview(capitalizationTitleLabel)
        statisticLeftStackView.addArrangedSubview(circulatingTitleLabel)
        
        statisticRightStackView.addArrangedSubview(capitalizationLabel)
        statisticRightStackView.addArrangedSubview(circulatingLabel)
    }

    private func setupConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        statisticView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(160)
            make.left.right.equalToSuperview()
        }
        statisticLeftStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(25)
        }
        statisticRightStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.right.equalToSuperview().inset(25)
        }
    }

    private func setupCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        let image = UIImage(named: "left-arrow")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        backButton.setImage(image, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.contentHorizontalAlignment = .fill
        backButton.contentVerticalAlignment = .fill
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: backButton)
        barItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        barItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true

        navigationItem.leftBarButtonItem = barItem
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

protocol DetailPresenterProtocol {
    func viewDidLoad()
}

class DetailPresenter: DetailPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private var currency: Currency

    init(view: DetailViewProtocol, currency: Currency) {
        self.view = view
        self.currency = currency
    }

    func viewDidLoad() {
        view?.displayTitle("\(currency.name) (\(currency.symbol))")
        view?.displayPrice(String(format: "$%.2f", currency.marketData.volumeLast24Hours))
        view?.displayPercent(String(format: "%.2f%%", currency.marketData.percent))
        view?.displayCapitalization(String(format: "$%.2f", currency.marketCapitalization.capitalization))
        view?.displayCirculating(String(format: "%.2f ETH", currency.supply.circulating))
    }
}
