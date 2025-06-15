//
//  PDFScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import Foundation

class PDFScreenViewModel {
    var coordinator: PDFScreenCoordinator?
    var fileName: String

    init(coordinator: PDFScreenCoordinator?, fileName: String) {
        self.coordinator = coordinator
        self.fileName = fileName
    }
    
    var fullPDFURL: URL? {
            let baseUrl = "http://localhost:5001/media/"
            return URL(string: baseUrl + fileName)
        }
}
