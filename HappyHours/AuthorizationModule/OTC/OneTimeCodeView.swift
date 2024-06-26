//
//  OneTimeCodeView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeView class

final class OneTimeCodeView: AuthScreenView {
    
    // MARK: Properties
    
    private let numberOfDigits: UInt
    private var digitsLabels = [UILabel]()
    var oneTimeCodeFilled: ((String) -> Void)?
    private var timer: Timer?
    private var secondsRemained = 0
    
    // MARK: UI components
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.textColor = .clear
        return textField
    }()
    
    private let cellsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let resendButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonTitleAttributes = AttributeContainer(
        [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.mainText
        ]
    )

    // MARK: Lifecycle
    
    init(numberOfDigits: UInt, email: String?) {
        self.numberOfDigits = numberOfDigits
        super.init(screenName: String(localized: "Enter Code"))
        setUpUI()
        if let email {
            descriptionLabel.text = String(localized: "Enter the code sent to \(email).")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubviews()
        setUpConstraints()
        configureLabels()
        codeTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func addSubviews() {
        addSubview(descriptionLabel)
        addSubview(codeTextField)
        codeTextField.addSubview(cellsStackView)
        addSubview(resendButton)
    }
    
    private func configureLabels() {
        for _ in 0..<numberOfDigits {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = .mainText
            label.font = .boldSystemFont(ofSize: 40)
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1
            label.clipsToBounds = true
            label.layer.cornerRadius = 5
            label.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(
                target: codeTextField,
                action: #selector(becomeFirstResponder)
            )
            label.addGestureRecognizer(gestureRecognizer)
            digitsLabels.append(label)
            cellsStackView.addArrangedSubview(label)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                Constraints.spaceBeforeFirstElement(for: descriptionLabel, under: screenNameLabel),
                Constraints.textFieldAndButtonWidthConstraint(for: descriptionLabel, on: self),
                descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                Constraints.topBetweenTextFieldsAndButtons(
                    for: codeTextField,
                    under: descriptionLabel
                ),
                codeTextField.widthAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.widthAnchor,
                    multiplier: 0.8
                ),
                codeTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: 0.1
                ),
                codeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                cellsStackView.topAnchor.constraint(equalTo: codeTextField.topAnchor),
                cellsStackView.leadingAnchor.constraint(equalTo: codeTextField.leadingAnchor),
                cellsStackView.trailingAnchor.constraint(equalTo: codeTextField.trailingAnchor),
                cellsStackView.bottomAnchor.constraint(equalTo: codeTextField.bottomAnchor),
                
                resendButton.topAnchor.constraint(equalTo: cellsStackView.bottomAnchor, constant: 10),
                resendButton.centerXAnchor.constraint(equalTo: cellsStackView.centerXAnchor)
            ]
        )
    }
    
    // MARK: User interaction
    
    @objc private func textDidChange() {
        guard let text = codeTextField.text, text.count <= numberOfDigits else { return }
        
        digitsLabels.enumerated().forEach { i, label in
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                label.text = String(text[index])
            } else {
                label.text?.removeAll()
            }
        }
        if text.count == numberOfDigits {
            oneTimeCodeFilled?(text)
            codeTextField.text?.removeAll()
            textDidChange()
        }
    }
    
    // MARK: Timer methods
    
    func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timerStep()
        }
        secondsRemained = 120
        resendButton.isEnabled = false
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        resendButton.isEnabled = true
        resendButton.configuration?.attributedTitle = AttributedString(
            String(localized: "Resend code"),
            attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 12),
                                            .foregroundColor: UIColor.main])
        )
    }
    
    private func timerStep() {
        guard secondsRemained > 0 else {
            stopTimer()
            return
        }
        
        secondsRemained -= 1
        self.resendButton.configuration?.attributedTitle = AttributedString(
            String(localized: "Resend code in \(self.timeFormatted(seconds: self.secondsRemained))"),
            attributes: self.buttonTitleAttributes
        )
    }
    
    private func timeFormatted(seconds: Int) -> String {
        let minutes = secondsRemained / 60
        let seconds = secondsRemained % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

// MARK: - UITextFieldDelegate

extension OneTimeCodeView {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let count = textField.text?.count else { return false }
        
        return count < numberOfDigits || string.isEmpty
    }
    
}
