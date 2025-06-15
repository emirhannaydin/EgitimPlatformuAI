//
//  ReadingBookViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

class ReadingBookViewModel {
    var coordinator: ReadingBookCoordinator?
    var books: [Books] = []
    init(coordinator: ReadingBookCoordinator?) {
        self.coordinator = coordinator
    }
    
    func fetchBooks(completion: @escaping (Result<[Books], Error>) -> Void) {
            NetworkManager.shared.getBooks { result in
                switch result {
                case .success(let books):
                    self.books = books
                    completion(.success(books))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
