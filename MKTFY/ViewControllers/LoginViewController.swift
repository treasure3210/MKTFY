//
//  LoginViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit
import Auth0

class LoginViewController: UIViewController {
    
    let auth0Manager = Auth0Manager()

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var passwordView: SecureTextField!
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let vc = ForgotPasswordViewController.storyboardInstance(storyboardName: "Login") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginValidation()
        
        guard let email = emailView.inputTextField.text, let password = passwordView.isSecureTextField.text else { return }

        auth0Manager.loginWithEmail(email, password: password) { success, error in
            if success {
                print("Login Successed!")
            } else {
                print("Failed to authenticate with Auth0: \(String(describing: error))")
            }
        }
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let vc = CreateAccountViewController.storyboardInstance(storyboardName: "Login") as! CreateAccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        
        self.emailView.inputTextField.delegate = self
        self.passwordView.isSecureTextField.delegate = self
        
        passwordView.isSecureTextField.setRightPaddingInTextField(padding: passwordView.isSecureTextField.frame.size.height, imageName: "eye.slash")
        
        if emailView.inputTextField.text!.isEmpty || passwordView.isSecureTextField.text!.isEmpty {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .disabled)
        } else {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.WarningYellow), forState: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
}

// Validating the Login Process
extension LoginViewController {
    
    private func loginValidation() {
        guard let emailTextField = emailView.inputTextField, let passwordTextField = passwordView.isSecureTextField else {
            assertionFailure("Email and/or password should never be nil.")
            return
        }
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            return
        } else if emailTextField.text!.isEmpty == false {
            
        }
        
    }
    
    // Simple method to control the color state of the button.
    func changeButtonColor(){
        if emailView.inputTextField.text!.isEmpty || passwordView.isSecureTextField.text!.isEmpty {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.WarningYellow), forState: .normal)
        }
 
    }
    
    // Enable dismiss of keyboard when the user taps anywhere from the screen
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
        changeButtonColor()
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else {
            removeBorderColor()
            emailView.showError = false
        }
    }
    
    // Triggers the error message
    private func configureView(withMessage message: String){
        emailView.showError = true
        emailView.errorMessage = message
    }
    
    // Extension to shift the view upward or downward when system keyboard appears
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 100 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    // Extension to customize border color to indicate whether a textfield is empty or not
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        emailView.inputTextField.layer.borderWidth = 1
        emailView.inputTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        emailView.inputTextField.layer.borderWidth = 0
        emailView.inputTextField.layer.borderColor = nil
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        changeButtonColor()
        
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else {
            removeBorderColor()
            emailView.showError = false
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

