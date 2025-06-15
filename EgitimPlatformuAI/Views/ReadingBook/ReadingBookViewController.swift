//
//  ReadingBookViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit
import PDFKit


import UIKit

final class ReadingBookViewController: UIViewController{

    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var collectionView: UICollectionView!
    var books: [Books] = []

    var viewModel: ReadingBookViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.showLottieLoading()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadBooks()
    }
    
    private func loadBooks() {
        viewModel?.fetchBooks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self?.books = books
                    self?.collectionView.reloadData()
                    self?.hideLottieLoading()
                case .failure(let error):
                    self?.hideLottieLoading()
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
    }

    private func setupUI() {
        collectionView.register(BookCell.nib(), forCellWithReuseIdentifier: BookCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        backButton.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    @objc func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }

    
}

extension ReadingBookViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as! BookCell
        cell.contentView.backgroundColor = .clear
        cell.configure(with: books[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.item]
        let pdfCoordinator = PDFScreenCoordinator.getInstance()
        let pdfViewModel = PDFScreenViewModel(coordinator: pdfCoordinator, fileName: selectedBook.fileName)
        
        pdfCoordinator.start(with: pdfViewModel)
        ApplicationCoordinator.getInstance().pushFromTabBarCoordinatorAndVariables(pdfCoordinator, hidesBottomBar: true)
        
    }
}



