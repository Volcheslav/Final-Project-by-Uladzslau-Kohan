//
//  UserProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/31/22.
//

import UIKit

final class UserProfileViewController: UIViewController {
    
    private let tableNameHeaderHeigt: CGFloat = 100
    private let tableInfoHeaderHeigh: CGFloat = 60
    private let tableRowHeight: CGFloat = 70
    
    // MARK: Outlets
    
    @IBOutlet private weak var profileInfoTable: UITableView!
    @IBOutlet private weak var signUpButton: UICustomButton!
    @IBOutlet private weak var loginButton: UICustomButton!
    @IBOutlet private weak var backTologinButton: UICustomButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginPasswordView: UIView!
    @IBOutlet private weak var profileInfoView: UIView!
    // MARK: Actions
    
    @IBAction private func goBackToLogin(_ sender: UICustomButton) {
        animateHideEmailTextfield()
    }
    @IBAction private func loginAction(_ sender: UICustomButton) {
        guard usernameTextField.hasText, passwordTextField.hasText else {
            self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        self.dismissMyKeyboard()
        self.loginUser(
            login: usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            password: passwordTextField.text!
        )
    }
    
    @IBAction private func signUpAction(_ sender: UICustomButton) {
        
        if self.loginButton.isHidden {
            guard usernameTextField.hasText, passwordTextField.hasText, emailTextField.hasText else {
                self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
                return
            }
            guard emailTextField.text!.isValidEmail() else {
                self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_EMIAL")§)
                return
            }
            self.dismissMyKeyboard()
            self.signUp(
                login: usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                password: passwordTextField.text!
            )
        } else {
            animateEmailTextfield()
        }
    }
    
    // MARK: LoadView functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeHideKeyboard()
        self.loginPasswordView.isHidden = true
        self.loginPasswordView.layer.cornerRadius = 20
        self.loginPasswordView.layer.masksToBounds = true
        
        self.passwordTextField.placeholder = ("ENTER_YOUR_PASSWORD")§
        self.usernameTextField.placeholder = ("ENTER_YOUR_LOGIN")§
        self.emailTextField.placeholder = ("ENTER_YOUR_EMAIL")§
        self.emailTextField.keyboardType = .emailAddress
        self.loginButton.setTitle(("LOGIN")§, for: .normal)
        self.signUpButton.setTitle(("SIGN_UP")§, for: .normal)
        self.backTologinButton.setTitle(("PROFILE_BACK_TO_LOGIN")§, for: .normal)
        
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let user: ParseUserData? = ParseUserData.current
        self.loginPasswordView.isHidden = user != nil
        self.profileInfoView.isHidden = user == nil
        self.loginButton.isHidden = false
        self.emailTextField.isHidden = true
        self.backTologinButton.isHidden = true
        self.profileInfoTable.reloadData()
    }
    
    // MARK: Login, SignUp
    // swiftlint: disable: empty_enum_arguments
    private func signUp(login: String, email: String?, password: String) {
        let newUser = ParseUserData(username: login, email: email, password: password)
        newUser.signup {[weak self] result in
            switch result {
            case .success(_):
                self?.successSignUp()
            case .failure(let error):
                self?.showAlertMessage(title: ("ERROR")§, message: "\(error.message)")
            }
        }
    }
    
    private func loginUser(login: String, password: String) {
        ParseUserData.login(username: login, password: password, completion: {[weak self] result in
                                switch result {
                                case .success(_):
                                    self?.successEnter()
                                case .failure(_):
                                    self?.showAlertMessage(title: ("ERROR")§, message: ("PROFILE_NOT_VALID_REGISTRATION")§)
                                }})
    }
    
    private func successEnter() {
        self.profileInfoTable.reloadData()
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.loginPasswordView.isHidden = true
        self.profileInfoView.isHidden = false
        self.showSuccessAlert(title: "\(("SUCCESS")§) \(ParseUserData.current?.username ?? "John Doe") \(("LOGGED_IN")§)", viewController: self)
        
    }
    
    private func successSignUp() {
        self.showAlertMessage(title: ("SUCCESS")§, message: ("SIGNED_UP")§)
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.animateHideEmailTextfield()
    }
    
    private func animateEmailTextfield() {
        guard self.emailTextField.isHidden else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.emailTextField.isHidden = false
            self?.loginButton.isHidden = true
            self?.backTologinButton.isHidden = false
        })
    }
    
    private func animateHideEmailTextfield() {
        guard !self.emailTextField.isHidden else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.emailTextField.isHidden = true
            self?.backTologinButton.isHidden = true
            self?.loginButton.isHidden = false
        })
    }
    
    // MARK: Alert functions
    
    private func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addCancelAction()
        self.present(alert, animated: true)
    }
    
    private func showSuccessAlert(title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Keybord functions
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height / 2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}

// MARK: - Keyboard extension

extension UserProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Table extensions

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumber: Int
        switch section {
        case 0:
            sectionNumber = 2
        case 1:
            sectionNumber = 5
        default:
            sectionNumber = 0
        }
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeaderTitle: String
        switch section {
        case 0:
            sectionHeaderTitle = ("MAIN")§
        case 1:
            sectionHeaderTitle = ("CONTACTS")§
        case 2:
            sectionHeaderTitle = ("ADDRESS")§
        default:
            sectionHeaderTitle = ""
        }
        return sectionHeaderTitle
    }
    
    // MARK: - Custom headers
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableNameHeaderHeigt))
            let label = UILabel()
            label.frame = .init(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            DispatchQueue.main.async {
                label.text = "\(("HELLO")§), \(ParseUserData.current?.username ?? "John Doe")"
            }
            label.font = .systemFont(ofSize: 44)
            label.textColor = .white
            label.textAlignment = .center
            headerView.addSubview(label)
            label.center = headerView.center
            headerView.layer.cornerRadius = 45
            headerView.layer.masksToBounds = true
            headerView.backgroundColor = .systemGray2
            return headerView
            
        case 1:
            let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableInfoHeaderHeigh))
            let label = UILabel(frame: .init(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.width - 10))
            label.text = "\(("USER_DATA")§)"
            label.font = .systemFont(ofSize: 30)
            label.textColor = .white
            label.textAlignment = .center
            headerView.addSubview(label)
            label.center = headerView.center
            headerView.backgroundColor = .systemGray2
            return headerView
        default:
            return .init()
        }
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        switch section {
        case 0:
            headerHeight = self.tableNameHeaderHeigt
        case 1:
            headerHeight = self.tableInfoHeaderHeigh
        default:
            headerHeight = 0
        }
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "profileCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserProfileTableViewCell else { return .init() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableRowHeight
    }
    
}
// MARK: - Email valid check

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}