//
//  PDFScreenViewModel.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

class PDFScreenViewModel {
    var coordinator: PDFScreenCoordinator?
    var fileName: String

    init(coordinator: PDFScreenCoordinator?, fileName: String) {
        self.coordinator = coordinator
        self.fileName = fileName
    }
}
