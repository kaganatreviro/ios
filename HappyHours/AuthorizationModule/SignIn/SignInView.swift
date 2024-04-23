//
//  SignInView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

// MARK: - SignInView

final class SignInView: AuthScreenView {
    
    // MARK: UI components
    
    let emailTextField = CommonTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let passwordTextField = CommonTextField(
        placeholder: String(localized: "Password"),
        textContentType: .password
    )
    
    let logInButton = CommonButton(title: "Log In")
    
    let resetButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Reset Password"),
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12),
                                            .foregroundColor: UIColor.mainText])
        )
        button.configuration?.baseForegroundColor = .black
        return button
    }()
    
    private let signUpStackView = SignUpStackView()
    
    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Sign In to Continue"))
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(logInButton)
        addSubview(resetButton)
        addSubview(signUpStackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                emailTextField.topAnchor.constraint(
//                    equalToSystemSpacingBelow: screenNameLabel.bottomAnchor,
//                    multiplier: AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
//                ),
                Constraints.spaceBeforeFirstElement(for: emailTextField, under: screenNameLabel),
//                emailTextField.widthAnchor.constraint(
//                    equalTo: widthAnchor,
//                    multiplier: Constraints.textFieldWidthMultiplier
//                ),
                Constraints.textFieldAndButtonWidthConstraint(for: emailTextField, on: self),
//                emailTextField.heightAnchor.constraint(
//                    equalTo: safeAreaLayoutGuide.heightAnchor,
//                    multiplier: Constraints.textFieldHeightMultiplier
//                ),
                Constraints.textFieldAndButtonHeighConstraint(for: emailTextField, on: self),
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                passwordTextField.topAnchor.constraint(
//                    equalToSystemSpacingBelow: emailTextField.bottomAnchor,
//                    multiplier: Constraints.topBetweenTextFieldsMultiplier
//                ),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: passwordTextField,
                    under: emailTextField
                ),
                passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
//                logInButton.topAnchor.constraint(
//                    equalToSystemSpacingBelow: passwordTextField.bottomAnchor,
//                    multiplier: Constraints.topBetweenTextFieldsMultiplier
//                ),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: logInButton,
                    under: passwordTextField
                ),
                logInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                logInButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                logInButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                resetButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: logInButton.bottomAnchor,
                    multiplier: 1.2
                ),
                resetButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
                
                signUpStackView.topAnchor.constraint(greaterThanOrEqualTo: resetButton.bottomAnchor, constant: -5),
                signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

                keyboardLayoutGuide.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 10)
            ]
        )
    }
    
}
