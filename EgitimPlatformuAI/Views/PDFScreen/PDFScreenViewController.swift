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

        guard let fileName = viewModel?.fileName,
              let url = Bundle.main.url(forResource: fileName, withExtension: "pdf"),
              let document = PDFDocument(url: url) else {
            showAlert(title: "Error", message: "PDF can not be loaded")
            return
        }
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .horizontal

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }
}

