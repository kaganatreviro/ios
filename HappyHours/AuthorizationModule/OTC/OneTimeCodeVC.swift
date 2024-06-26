//
//  OneTimeCodeVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeVC class

final class OneTimeCodeVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var otcView = OneTimeCodeView(numberOfDigits: 4, email: model.resetEmail)
    private let model: AuthorizationModelProtocol

    // MARK: Lifecycle
    
    init(model: AuthorizationModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = otcView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        otcView.startCountdown()
        setUpResending()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otcView.codeTextField.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        otcView.oneTimeCodeFilled = { [weak self] code in
            guard let self, let code = self.otcView.codeTextField.text else { return }
            
            otcView.stopTimer()
            Task {
                do {
                    try await self.model.sendOTC(code)
                    self.navigationController?.pushViewController(
                        NewPasswordVC(model: self.model),
                        animated: true
                    )
                } catch APIError.otcExpired {
                    self.showAlert(.otcExpired)
                } catch {
                    self.showAlert(.incorrectOTC)
                }
            }
        }
    }

    // MARK: Code resending
    
    private func setUpResending() {
        otcView.resendButton.addAction(UIAction { [weak self] _ in
            guard let self, let email = self.model.resetEmail else { return }
            Task {
                do {
                    try await self.model.sendEmailForOTC(email)
                    self.otcView.startCountdown()
                } catch {
                    self.showAlert(.sendingEmailServerError)
                }
            }
        }, for: .touchUpInside)
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    OneTimeCodeVC(
        model: AuthorizationModel(
            networkService: NetworkService(
                authService: AuthService(
                    keyChainService: KeyChainService()
                )
            )
        )
    )
    
}
