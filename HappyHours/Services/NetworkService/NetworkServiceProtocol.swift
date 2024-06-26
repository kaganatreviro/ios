//
//  NetworkServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import UIKit

protocol NetworkServiceProtocol: Actor {
    
    func logIn(_ logIn: LogIn) async throws
    func createUser(_ user: CreateUser) async throws
    func logOut() async throws
    func getRestaurants(
        limit: UInt,
        offset: UInt,
        search: String?,
        allowRetry: Bool
    ) async throws -> [Restaurant]
    func getImage(from url: URL) async -> UIImage?
    func getUser(allowRetry: Bool) async throws -> User
    func editUser(
        imageData: Data?,
        name: String?,
        dateOfBirth: Date?,
        allowRetry: Bool
    ) async throws
    func sendEmailForOTC(_ email: ResetPassword) async throws
    func sendOTC(_ otc: OTC) async throws
    func setNewPassword(_ password: NewPassword, allowRetry: Bool) async throws
    func getMenu(
        restaurantID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool
    ) async throws -> [Beverage]
    func getRestaurants(
        latitude: Double,
        longitude: Double,
        metersRadius: Int,
        allowRetry: Bool
    ) async throws -> [Restaurant]
    func getRestaurant(id: Int, allowRetry: Bool) async throws -> Restaurant
    func getBeverages(
        limit: UInt,
        offset: UInt,
        search: String?,
        allowRetry: Bool
    ) async throws -> BeverageResponse
    func makeOrder(_ order: PlaceOrder, allowRetry: Bool) async throws
    func getOrders(
        limit: UInt,
        offset: UInt,
        allowRetry: Bool
    ) async throws -> OrdersResponse
    func getFeedbacks(
        restaurantID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool
    ) async throws -> FeedbackResponse
    func getFeedbackAnswers(
        feedbackID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool
    ) async throws -> FeedbackAnswersResponse
    func sendFeedback(_ feedback: SendFeedback) async throws
    func sendFeedbackAnswer(_ feedbackAnswer: FeedbackAnswerCreate) async throws
    func getActiveSubscription(allowRetry: Bool) async throws -> Subscription
    func getSubscriptionPlans(allowRetry: Bool) async throws -> [SubscriptionPlan]
    func createPayment(subscriptionPlanID: Int, allowRetry: Bool) async throws -> Payment
    func createFreeTrial(freeTrial: FreeTrial, allowRetry: Bool) async throws
}
