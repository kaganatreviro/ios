//
//  BeverageResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import Foundation

struct BeverageResponse: Decodable {
    
    let results: [Beverage]
    
}

struct Beverage: Decodable {
    
    let id: Int
    let name: String
    let price: String
    let description: String
    let category: String
    
}
