//
//  SignInVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit
//import OpenAPIRuntime
//import OpenAPIURLSession

// MARK: - SignInVC class

/// This class is made for the first logging in were user can enter the email and password, reset the password or sign up
final class SignInVC: UIViewController, EmailChecker, PasswordChecker, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var signInView = SignInView()
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
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        
//        Task {
//            do {
//                try await model.logIn(email: "user@example.com", password: "stringst")
//            } catch {
//                print(error)
//            }
//        }
    
//        let client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
//        
//        Task {
//            do {
//                let response = try await client.v1_user_token_create(
//                    body: .json(.init(email: "user@example.com", password: "stringst"))
//                )
//                
//                switch response {
//                case let .ok(okResponse):
//                    switch okResponse.body {
//                    case .json(let token):
//                        print(token)
//                        let client = Client(
//                            serverURL: try! Servers.server1(),
//                            transport: URLSessionTransport(),
//                            middlewares: [AuthenticationMiddleware(
//                                token: token.access
//                            )]
//                        )
//                        let response = try await client.v1_beverage_beverages_list(query: .init(limit: 1))
//                        switch response {
//                        case let .ok(okResponse):
//                            switch okResponse.body {
//                            case .json(let beverages):
//                                print(beverages.results)
//                            }
//                        case .undocumented(statusCode: let statusCode, _):
//                            print(statusCode)
//                        }
//                    }
//                case .undocumented(statusCode: let statusCode, _):
//                    print(statusCode)
//                }
//            } catch {
//                print(error)
//            }
//        }
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        signInView.resetButton.addTarget(
            self,
            action: #selector(goToResetPasswordVC),
            for: .touchUpInside
        )
        signInView.logInButton.addTarget(
            self,
            action: #selector(goToMainModule),
            for: .touchUpInside
        )
    }
    
    @objc private func goToMainModule() {
//        guard isValidCredentials() else { return }
        guard let email = signInView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return
        }
        
        guard let password = signInView.passwordTextField.text, isValidPassword(password) else {
            showAlert(.invalidPasswordLength)
            return
        }
        
        signInView.isLoggingIn = true
        Task {
            do {
                try await model.logIn(email: email, password: password)
                UIApplication.shared.sendAction(
                    #selector(LogInDelegate.logIn),
                    to: nil,
                    from: self,
                    for: nil
                )
                signInView.isLoggingIn = false
            } catch {
                showAlert(.accessDenied)
                signInView.isLoggingIn = false
            }
        }
    }
    
    @objc private func goToResetPasswordVC() {
        navigationController?.pushViewController(ResetPasswordVC(), animated: true)
    }
    
//    private func isValidCredentials() -> Bool {
//        guard let email = signInView.emailTextField.text, isValidEmail(email) else {
//            showAlert(.invalidEmail)
//            return false
//        }
//        
//        guard let password = signInView.passwordTextField.text, isValidPassword(password) else {
//            showAlert(.invalidPasswordLength)
//            return false
//        }
//        
//        return true
//    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    SignInVC(model: AuthorizationModel(networkService: NetworkService()))
}

// MARK: - SignUpStackViewDelegate

extension SignInVC: SignUpStackViewDelegate {
    
    func goToSignUp() {
        navigationController?.pushViewController(SignUpVC(model: model), animated: true)
    }
    
}
