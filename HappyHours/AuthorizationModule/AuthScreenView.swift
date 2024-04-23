//
//  AuthScreenView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

// MARK: - AuthScreenView class

/// This is the base class for authentication screens which contains application name label and screen name label.
class AuthScreenView: UIView {
    
    // MARK: UI components

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.font = UIFont(name: "Inter-Regular_Bold", size: 24)
        label.textAlignment = .center
        label.textColor = .mainText
        label.text = String(localized: "Happy Hours")
        return label
    }()
    
    let screenNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .mainText
        return label
    }()
    
    // MARK: Lifecycle
    
    init(screenName: String) {
        super.init(frame: .zero)
        screenNameLabel.text = screenName
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let textField = subview as? UITextField {
            textField.delegate = self
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(#function)
//    }
    
//    override func updateConstraints() {
//        print(needsUpdateConstraints())
//        setUpConstrains()
//        super.updateConstraints()
//        print(#function)
//    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstrains()
        // TODO: Decide whether to use keyboardLayoutGuide or both
//        setUpKeyboardShowAndHiding()
    }
    
    private func addSubviews() {
        addSubview(appNameLabel)
        addSubview(screenNameLabel)
    }
    // TODO: Decide whether to use keyboardLayoutGuide or both
//    private func setUpKeyboardShowAndHiding() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(moveUpContent(notification:)),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(moveDownContent),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
    
    private func setUpConstrains() {
        NSLayoutConstraint.activate(
            [
                appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                //            appNameLabel.topAnchor.constraint(
                //                lessThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                //                constant: frame.height * AuthSizes.appNameLabelTopMultiplier
                //            ),
                appNameLabel.topAnchor.constraint(
                    lessThanOrEqualToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor,
                    multiplier: 1.8
                ),
                
                screenNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                screenNameLabel.topAnchor.constraint(
//                    equalTo: appNameLabel.bottomAnchor,
//                    constant: frame.height * AuthSizes.screenNameLabelTopMultiplier
//                )
                screenNameLabel.topAnchor.constraint(
                    lessThanOrEqualToSystemSpacingBelow: appNameLabel.bottomAnchor,
                    multiplier: 13
                ),
                screenNameLabel.topAnchor.constraint(greaterThanOrEqualTo: appNameLabel.bottomAnchor)
            ]
        )
    }
    
    // MARK: User interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    // TODO: Decide whether to use keyboardLayoutGuide or both
//    /// This method moves up the content when the keyboard appears.
//    /// - Parameter notification: A notification to get the keyboard size
//    @objc private func moveUpContent(notification: NSNotification) {
//        guard let elementFrame = moveUpContentToElement()?.frame,
//              let keyboardHeight = (notification.userInfo?[
//                UIResponder.keyboardFrameEndUserInfoKey
//              ] as? CGRect)?.height
//        else { return }
//        
//        let emptySpaceHeigh = frame.height - elementFrame.origin.y - elementFrame.height
//        
//        UIView.animate(withDuration: 0.4) {
//            self.frame.origin.y = -(keyboardHeight - emptySpaceHeigh) - 5
//        }
//    }
//
//    
//    /// This method should be overridden in every subclass that should move up the content when the keyboard appears.
//    /// - Returns: should return the frame of the element to which to move up the content
//    func moveUpContentToElement() -> UIView? {
//        nil
//    }
//    
//    @objc private func moveDownContent() {
//        frame.origin.y = 0
//    }
    
}

// MARK: - UITextFieldDelegate

extension AuthScreenView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
