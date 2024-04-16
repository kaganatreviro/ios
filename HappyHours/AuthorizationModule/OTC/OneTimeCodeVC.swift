//
//  OneTimeCodeVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeVC class

final class OneTimeCodeVC: UIViewController {
    
    // MARK: Properties
    
    private let otcView = OneTimeCodeView(numberOfDigits: 4)

    // MARK: Lifecycle
    
    override func loadView() {
        view = otcView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otcView.codeTextField.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        otcView.oneTimeCodeFilled = { [weak self] code in
            // TODO: Set up real navigation
            print("Code \(code) was entered")
        }
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    OneTimeCodeVC()
}
