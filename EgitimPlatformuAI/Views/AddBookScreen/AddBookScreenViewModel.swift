//
//  AddBookScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.06.2025.
//

import Foundation

class AddBookScreenViewModel {
    var coordinator: AddBookScreenCoordinator?
    
    init(coordinator: AddBookScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
        
    func uploadBookFile(fileURL: URL, completion: @escaping (Result<PDFUploadResponse, Error>) -> Void) {
            NetworkManager.shared.uploadFile(fileURL: fileURL) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func uploadBookMetadata(title: String, coverName: String, fileName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.uploadBookMetadata(title: title, coverName: coverName, fileName: fileName) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}
