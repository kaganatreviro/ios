//
//  MenuModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

protocol MenuModelProtocol {
    
    var restaurant: Restaurant { get }
    var menu: [(category: String, beverages: [Beverage])] { get }
    var logoImage: UIImage? { get async }
    
    func updateMenu(restaurantID: Int, limit: UInt, offset: UInt) async throws
    func makeOrder(_ order: Order) async throws
    
}
