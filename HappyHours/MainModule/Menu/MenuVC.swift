//
//  MenuVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

// MARK: - MenuVC class

final class MenuVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var menuView = MenuView()
    private let model: MenuModelProtocol
    private let areOrdersEnable: Bool
    
    // MARK: Lifecycle
    
    init(model: MenuModelProtocol, areOrdersEnable: Bool) {
        self.model = model
        self.areOrdersEnable = areOrdersEnable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        menuView.restaurantHeaderView.set(restaurant: model.restaurant)
        Task {
            do {
                try await model.updateMenu(restaurantID: model.restaurant.id, limit: 100, offset: 0)
                menuView.tableView.reloadData()
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                showAlert(.gettingMenuServerError)
            }
        }
        Task {
            menuView.restaurantHeaderView.logoImageView.image = await model.logoImage
        }
    }

}

// MARK: - UITableViewDataSource

extension MenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.menu.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.menu[section].category.capitalized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menu[section].beverages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = menuView.tableView.dequeueReusableCell(
            withIdentifier: MenuTableViewCell.identifier,
            for: indexPath
        ) as? MenuTableViewCell else { return UITableViewCell() }
        
        let beverage = model.menu[indexPath.section].beverages[indexPath.row]
        
        cell.configure(beverage: beverage, isOrderEnable: areOrdersEnable, delegate: self)

        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beverage = model.menu[indexPath.section].beverages[indexPath.row]
        let beverageVC = BeverageVC(beverage: beverage)
        beverageVC.sheetPresentationController?.prefersGrabberVisible = true
        beverageVC.sheetPresentationController?.detents = [.medium(), .large()]
        present(beverageVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - MenuTableViewCellDelegate

extension MenuVC: MenuTableViewCellDelegate {
    
    func didClickOnCellWith(beverageID: Int) {
        Task {
            do {
                let order = PlaceOrder(beverage: beverageID)
                try await model.makeOrder(order)
                showAlert(.orderMade)
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                showAlert(.makingOrderServerError)
            }
        }
    }
    
}
