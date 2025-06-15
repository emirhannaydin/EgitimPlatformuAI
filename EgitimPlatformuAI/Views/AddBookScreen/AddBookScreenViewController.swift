//
//  AddBookScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 15.06.2025.
//

import UIKit
import Foundation
import UniformTypeIdentifiers

final class AddBookScreenViewController: UIViewController{
    
    @IBOutlet var bookNameTextField: UITextField!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var selectBookButton: UIButton!
    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var selectCoverButton: UIButton!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var uploadBookButton: UIButton!
    
    private var imageName: String!
    var viewModel: AddBookScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @IBAction func selectBookHandler(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true)
    }
    @IBAction func selectCoverHandler(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)

    }
    @IBAction func uploadBookHandler(_ sender: Any) {
        guard let bookTitle = bookNameTextField.text,
                  !bookTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "Error", message: "Please enter the book name.", lottieName: "error")
                return
            }
            
            guard coverImage.image != nil else {
                showAlert(title: "Error", message: "Please select a cover image.", lottieName: "error")
                return
            }
            
            guard let bookFileName = bookNameLabel.text,
                  !bookFileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  bookFileName != "Selected file:" else {
                showAlert(title: "Error", message: "Please select a book PDF file.", lottieName: "error")
                return
            }
        
        viewModel!.uploadBookMetadata(title: bookTitle, coverName: imageName, fileName: bookFileName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "The book has been uploaded to the system.", lottieName: "success")
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddBookScreenViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        
        let fileName = selectedURL.lastPathComponent
        let fileExtension = selectedURL.pathExtension.lowercased()

        if ["jpg", "jpeg", "png", "heic"].contains(fileExtension) {
            if let imageData = try? Data(contentsOf: selectedURL),
               let image = UIImage(data: imageData) {
                self.coverImage.image = image
                self.imageName = fileName
            }

        } else if fileExtension == "pdf" {
            self.bookNameLabel.text = fileName
            self.coverImage.image = nil
        }


        viewModel!.uploadBookFile(fileURL: selectedURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.showAlert(title: "Success", message: "\(response.message)", lottieName: "success")
                case .failure(let error):
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)", lottieName: "error")
                }
            }
        }
    }
}

