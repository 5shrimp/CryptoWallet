//
//  ViewController.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 25.04.2025.
//



import UIKit
import SnapKit

// MARK: - View
protocol LoginViewProtocol: AnyObject {
    func showError(message: String)
    func clearFields()
    func showTabBar()
}

class LoginVC: UIViewController, LoginViewProtocol {
    lazy var presenter: LoginPresenterProtocol = LoginPresenter(view: self)

    private var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 79")
        return image
    }()

    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private var usernameTextEditForm: TextEditForm = {
        TextEditForm("user", "Username")
    }()

    private var passwordTextEditForm: TextEditForm = {
        TextEditForm("user", "Password")
    }()

    private var loginButton: UIButton = {
        let login = UIButton()
        login.setTitle("Login", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.backgroundColor = UIColor(red: 25/255.0, green: 28/255.0, blue: 48/255.0, alpha: 1.0)
        login.layer.cornerRadius = 25
        return login
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        registerForKeyboardNotifications()
        setupHideKeyboardOnTap()
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.checkAuthStatus()
    }

    @objc func loginTapped() {
        let username = usernameTextEditForm.textField.text ?? ""
        let password = passwordTextEditForm.textField.text ?? ""
        presenter.didTapLogin(username: username, password: password)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка входа", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel) { _ in
            self.clearFields()
        })
        present(alert, animated: true)
    }

    func clearFields() {
        usernameTextEditForm.textField.text = ""
        passwordTextEditForm.textField.text = ""
    }

    func showTabBar() {
        let tabBarVC = TabBarController()
        present(tabBarVC, animated: true)
    }
}

// MARK: - UI

private extension LoginVC {
    func setupViews() {
        view.backgroundColor = UIColor(red: 243/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1.0)
        view.addSubview(imageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(usernameTextEditForm)
        stackView.addArrangedSubview(passwordTextEditForm)
        stackView.addArrangedSubview(loginButton)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(128)
            make.left.right.equalTo(view).inset(32)
        }
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard view.frame.origin.y == 0,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.y -= keyboardFrame.height * 0.7
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.y = 0
        }
    }

    func setupHideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Presenter & Protocols

protocol LoginPresenterProtocol {
    func viewDidLoad()
    func checkAuthStatus()
    func didTapLogin(username: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?

    init(view: LoginViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {}

    func checkAuthStatus() {
        guard let credentials = KeychainService.shared.load(),
              credentials.login == "1234", credentials.password == "1234" else { return }
        view?.showTabBar()
    }

    func didTapLogin(username: String, password: String) {
        if username == "1234", password == "1234" {
            KeychainService.shared.save(login: "1234", password: "1234")
            view?.showTabBar()
        } else {
            view?.showError(message: "Введены неправильный логин или пароль")
        }
    }
}
