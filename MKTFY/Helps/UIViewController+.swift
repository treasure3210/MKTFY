//
//  UIViewController+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import Foundation
import UIKit

extension UIViewController {
    static func storyboardInstance(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
}

extension UIViewController {
    func setupNavigationBarWithBackButton() {
        // Controls the back button's action and style
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.appColor(LPColor.LightestPurple)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // Determines where the back button should take the view controller to
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBarWithMenuButton() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu_button"), style: .plain, target: self, action: #selector(menuButtonTapped))
        menuButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        self.navigationItem.leftBarButtonItem = menuButton
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = UIColor.appColor(LPColor.TextGray)
        self.navigationItem.rightBarButtonItem = searchButton
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        navigationItem.titleView = containerView
        
        let textField = UITextField()
        textField.placeholder = "Search on MKTFY"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: navigationItem.titleView!.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: navigationItem.titleView!.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: navigationItem.titleView!.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: navigationItem.titleView!.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
        
        navigationController?.navigationBar.frame.size.height = 100
        navigationController?.navigationBar.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
    
    @objc func menuButtonTapped() {
        let vc = DashboardMenuViewController.storyboardInstance(storyboardName: "Dashboard") as! DashboardMenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButtonTapped() {
        
    }
    
    func setupNavigationBarWithExitButtonOnRight() {
        let exitButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitButtonTapped))
        exitButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = exitButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @objc func exitButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func setupBackgroundView(view: UIView) {
        let backgroundView = view
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
    }
}

// Show Alert
extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
