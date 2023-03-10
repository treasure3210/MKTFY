//
//  CreateAccountViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class CreateAccountViewController: MainViewController, CreatePasswordDelegate, LoginStoryboard {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var firstNameField: TextFieldWithError!
    @IBOutlet weak var lastNameField: TextFieldWithError!
    @IBOutlet weak var emailField: TextFieldWithError!
    @IBOutlet weak var phoneField: TextFieldWithError!
    @IBOutlet weak var addressField: TextFieldWithError!
    @IBOutlet weak var cityField: TextFieldWithError!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var nextButton: Button!
    
    // MARK: - @IBAction
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty && email.isValidEmail,
              !phone.isEmpty,
              !address.isEmpty,
              !city.isEmpty else { return }
        
        let vc = CreatePasswordViewController.storyboardInstance(storyboardName: "Login") as! CreatePasswordViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        initializeImageDropDown()
        
        self.firstNameField.inputTextField.delegate = self
        self.lastNameField.inputTextField.delegate = self
        self.emailField.inputTextField.delegate = self
        self.phoneField.inputTextField.delegate = self
        self.addressField.inputTextField.delegate = self
        self.cityField.inputTextField.delegate = self
        
        /// Check if all textfields are not empty
        [firstNameField.inputTextField, lastNameField.inputTextField, emailField.inputTextField, phoneField.inputTextField, addressField.inputTextField, cityField.inputTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        nextButton.isEnabled = false
        nextButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        
        emailField.inputTextField.keyboardType = .emailAddress
        phoneField.inputTextField.keyboardType = .numberPad
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
    }
    
}

// MARK: - Extension
extension CreateAccountViewController {
    func changeButtonColor(){
        let textField = TextFieldWithError()
        
        if textField.inputTextField.text!.isEmpty {
            nextButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        } else {
            nextButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
    
    func initializeImageDropDown() {
        let imgViewForDropDown = UIImageView()
        imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 30, height: 48)
        imgViewForDropDown.image = UIImage(named: "drop_down_arrow")
        imgViewForDropDown.isUserInteractionEnabled = true

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imgViewForDropDown.frame.width + 10, height: imgViewForDropDown.frame.height))
        containerView.addSubview(imgViewForDropDown)

        cityField.inputTextField.rightView = containerView
        cityField.inputTextField.rightViewMode = .always

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropDownMenu))
        imgViewForDropDown.addGestureRecognizer(tapGesture)
        
        imgViewForDropDown.contentMode = .right
    }
    
    @objc func showDropDownMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let options = ["Calgary", "Camrose", "Brooks"]
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { (action) in
                self.cityField.inputTextField.text = option
                self.cityField.inputTextField.sendActions(for: .editingChanged)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func passwordCreated(_ password: String) {
        
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text else { return }
        
        Auth0Manager.shared.signup(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone, address: address, city: city) { success, error in
            if success {
                print("Sign up succeeded!")
            } else {
                print("Failed to sign up: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createPasswordVC = segue.destination as? CreatePasswordViewController {
            createPasswordVC.delegate = self
        }
    }
    
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension CreateAccountViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension CreateAccountViewController: UITextFieldDelegate, UINavigationBarDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let allFieldsFilled = ![firstNameField, lastNameField, emailField, phoneField, addressField, cityField].contains { $0.inputTextField.text?.isEmpty ?? true }
        
        nextButton.isEnabled = allFieldsFilled
        nextButton.setBackgroundColor(allFieldsFilled && emailField.inputTextField.text!.isValidEmail ? UIColor.appColor(LPColor.OccasionalPurple) : UIColor.appColor(LPColor.DisabledGray), forState: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField.inputTextField {
            let currentText = textField.text ?? ""
            let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = newString.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#", addCountryCodePrefix: true)
            let countOfDigits = formattedText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression).count
            if countOfDigits > 11 {
                return false
            }
            
            textField.text = formattedText
            return false
        }
        
        return true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            let containsTextFields = view.subviews.contains { $0 is UITextField }
            if containsTextFields {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
        }
    }
}
