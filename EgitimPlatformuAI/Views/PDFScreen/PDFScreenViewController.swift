//
//  PDFScreen.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit
import PDFKit

final class PDFScreenViewController: UIViewController {
    
    let pdfView = PDFView()
    var viewModel: PDFScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        view.backgroundColor = .systemBackground

        guard let url = viewModel?.fullPDFURL else {
            showAlert(title: "Error", message: "Invalid file URL", lottieName: "error")
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let document = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                    self.pdfView.autoScales = true
                    self.pdfView.displayMode = .singlePageContinuous
                    self.pdfView.displayDirection = .horizontal
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "PDF could not be loaded", lottieName: "error")
                }
            }
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }
}

