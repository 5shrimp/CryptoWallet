//
//  HomeVC.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 26.04.2025.
//

import UIKit
import SnapKit

// MARK: - View

protocol HomeViewProtocol: AnyObject {
    func showCurrencies(_ currencies: [Currency])
    func showLoading(_ isLoading: Bool)
    func toggleRefreshView()
}

class HomeVC: UIViewController, HomeViewProtocol {
    lazy var presenter: HomePresenterProtocol = HomePresenter(view: self, trendingService: TrendingService(), navigationController: self.navigationController)

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Bold", size: 32)
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Frame 8"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()
    
    private lazy var refreshView: RefreshView = {
        let view = RefreshView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private let programLabel: UILabel = {
        let label = UILabel()
        label.text = "Affiliate program"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Learn more  ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "other 5")
        return imageView
    }()
    
    private var trendingView: TrendingBackView = {
        let view = TrendingBackView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }

    // MARK: - HomeViewProtocol

    func showCurrencies(_ currencies: [Currency]) {
        trendingView.update(currencyList: currencies)
    }

    func showLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func toggleRefreshView() {
        refreshView.isHidden.toggle()
    }

    // MARK: - UI Setup

    private func setupViews() {
        trendingView.delegate = self
        view.backgroundColor = UIColor(red: 241/255.0, green: 159/255.0, blue: 178/255.0, alpha: 1.0)

        view.addSubview(homeLabel)
        view.addSubview(exitButton)
        view.addSubview(programLabel)
        view.addSubview(moreButton)
        view.addSubview(backgroundImageView)
        view.addSubview(trendingView)
        view.addSubview(refreshView)

        trendingView.addSubview(activityIndicator)

        exitButton.addTarget(self, action: #selector(exitButtonTap), for: .touchUpInside)
        refreshView.delegate = self
    }

    private func setupConstraints() {
        homeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(25)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        programLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(126)
            make.left.equalToSuperview().offset(25)
        }
        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(168)
            make.left.equalToSuperview().offset(25)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(101)
            make.left.equalToSuperview().offset(189)
        }
        trendingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(258)
            make.left.right.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        refreshView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(88)
            make.right.equalToSuperview().inset(25)
            make.width.equalTo(157)
            make.height.equalTo(102)
        }
    }

    @objc func exitButtonTap() {
        presenter.didTapExit()
    }
}

// MARK: - Delegates

extension HomeVC: TrendingBackViewDelegate {
    func didTapCell(currency: Currency) {
        presenter.didSelectCurrency(currency)
    }
}

extension HomeVC: RefreshViewDelegate {
    func refreshButtonTapped() {
        presenter.didTapRefresh()
    }

    func exitButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Presenter & Protocols

protocol HomePresenterProtocol {
    func viewDidLoad()
    func didTapExit()
    func didTapRefresh()
    func didSelectCurrency(_ currency: Currency)
}

class HomePresenter: HomePresenterProtocol {
    private weak var view: HomeViewProtocol?
    private let trendingService: TrendingService
    private weak var navigationController: UINavigationController?

    init(view: HomeViewProtocol, trendingService: TrendingService = TrendingService(), navigationController: UINavigationController?) {
        self.view = view
        self.trendingService = trendingService
        self.navigationController = navigationController
    }

    func viewDidLoad() {
        fetchTrending()
    }

    func didTapExit() {
        view?.toggleRefreshView()
    }

    func didTapRefresh() {
        fetchTrending()
    }

    func didSelectCurrency(_ currency: Currency) {
        let detailVC = DetailVC()
        detailVC.currency = currency
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func fetchTrending() {
        view?.showLoading(true)
        trendingService.fetchCurrencyList { [weak self] currencies in
            self?.view?.showLoading(false)
            self?.view?.showCurrencies(currencies)
        }
    }
}
