//
//  RestaurantsModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class RestaurantsModel: RestaurantsModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private(set) var restaurants: [Restaurant] = []
    private let logoCache = NSCache<NSString, UIImage>()
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getRestaurants(limit: UInt, offset: UInt) async throws {
        restaurants = try await networkService.getRestaurants(
            limit: limit,
            offset: offset,
            search: nil,
            allowRetry: true
        )
    }
    
    func getLogo(stringURL: String) async -> UIImage? {
        if let logo = logoCache.object(forKey: stringURL as NSString) {
            return logo
        } else if let logoData = await networkService.getImageData(from: stringURL),
                  let logo = UIImage(data: logoData) {
            logoCache.setObject(logo, forKey: stringURL as NSString)
            return logo
        }
        
        return nil
    }
    
}
