//
//  VerifyEmailScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation

class VerifyEmailScreenViewModel {
    var coordinator: VerifyEmailScreenCoordinator?
    var userID: String?
    var isPasswordVerify: Bool = false
    init(coordinator: VerifyEmailScreenCoordinator?, userID: String, isPasswordVerify: Bool) {
        self.coordinator = coordinator
        self.userID = userID
        self.isPasswordVerify = isPasswordVerify
    }
    
    func verifyEmail(otpCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "Unknown"

        NetworkManager.shared.verifyEmail(userId: userID, code: otpCode) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyForgotPasswordCode(userId: String, otpCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
            NetworkManager.shared.forgotPasswordOTP(userId: userId, otpCode: otpCode) { result in
                completion(result)
            }
        }
}
