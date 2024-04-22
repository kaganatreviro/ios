//
//  AuthViewController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: Alerts
    
    enum AlertType {
        case invalidEmail
        case invalidPasswordLength
        case notMatchPasswords
        case accountCreated
        case emptyName
        case invalidName
    }
    
    func showAlert(_ type: AlertType, handler: ((UIAlertAction) -> Void)? = nil) {
        let message: String
        let title: String
        
        switch type {
        case .invalidEmail:
            title = String(localized: "Invalid Email")
            message = String(localized: "This email address is not valid.\nEnter a different address.")
        case .invalidPasswordLength:
            title = String(localized: "Invalid Password")
            message = String(localized: "This password is too short.\nPasswords are 8 and more characters long.")
        case .notMatchPasswords:
            title = String(localized: "Passwords do not Match")
            message = String(localized: "Enter your new passwords again.")
        case .emptyName:
            title = String(localized: "Empty Name")
            message = String(localized: "Please, enter your name.")
        case .accountCreated:
            title = String(localized: "Success")
            message = String(localized: "Your account was created.")
        case .invalidName:
            title = String(localized: "Invalid Name")
            message = String(localized: "Name should not be empty and contains digits.")
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        
        present(alertController, animated: true)
    }
    
}
