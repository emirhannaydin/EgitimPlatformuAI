//
//  ResetPasswordViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation

class ResetPasswordScreenViewModel {
    var coordinator: ResetPasswordScreenCoordinator?
    var userID: String
    init(coordinator: ResetPasswordScreenCoordinator?, userID: String) {
        self.coordinator = coordinator
        self.userID = userID
    }
    
    func resetPassword(userID: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        NetworkManager.shared.resetPassword(userId: userID, password: password) { result in
                completion(result)
            }
        }
    
    

}
