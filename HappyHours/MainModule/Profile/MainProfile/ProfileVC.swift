//
//  ProfileVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

// MARK: - ProfileVC class

final class ProfileVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var profileView = ProfileView()
    private let model: ProfileModelProtocol
    
    // MARK: Lifecycle
    
    init(model: ProfileModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        title = String(localized: "Profile")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        setUser()
        setSubscription()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        profileView.profileButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let editProfileVC = EditProfileVC(model: self.model)
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }, for: .touchUpInside)
        
        profileView.logOutButton.addAction(UIAction { [weak self] _ in
            self?.logOut()
        }, for: .touchUpInside)
        
        profileView.subscriptionButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Task {
                do {
                    let subscriptionModel: SubscriptionModelProtocol = SubscriptionModel(
                        networkService: self.model.networkService,
                        subscriptionService: self.model.subscriptionService)
                    
                    if try await self.model.isSubscriptionActive {
                        let subscriptionPlansVC = SubscriptionPlansVC(
                            model: subscriptionModel,
                            allowSubscribe: false
                        )
                        self.navigationController?.pushViewController(
                            subscriptionPlansVC, animated: true
                        )
                    } else {
                        let subscriptionPlansVC = SubscriptionPlansVC(
                            model: subscriptionModel,
                            allowSubscribe: true
                        )
                        self.navigationController?.pushViewController(
                            subscriptionPlansVC, animated: true
                        )
                    }
                } catch AuthError.invalidToken {
                    self.logOutWithAlert()
                }
            }
        }, for: .touchUpInside)
    }
    
    private func logOut() {
        let alertController = UIAlertController(
            title: String(localized: "Log Out"),
            message: String(localized: "Are you sure you want to logout?"),
            preferredStyle: .actionSheet
        )
        let logOutAction = UIAlertAction(
            title: String(localized: "Log Out"),
            style: .destructive
        ) { _ in
            Task {
                try await self.model.logOut()
            }
            UIApplication.shared.sendAction(#selector(LogOutDelegate.logOut),
                                            to: nil,
                                            from: self,
                                            for: nil
            )
        }
        alertController.addAction(logOutAction)
        alertController.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: Set user
    
    private func setUser() {
        Task {
            do {
                profileView.set(user: try await model.user)
                profileView.set(avatar: await model.avatarImage)
            } catch AuthError.invalidToken {
                self.logOut()
            } catch {
                showAlert(.getUserServerError)
            }
        }
    }
    
    // MARK: Set subscription
    
    private func setSubscription() {
        profileView.isLoadingSubscription = true
        Task {
            defer {
                profileView.isLoadingSubscription = false
            }
            do {
                let subscription = try await model.subscription
                profileView.set(subscription: subscription)
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                profileView.setSubscriptionError()
            }
        }
    }
    
}
