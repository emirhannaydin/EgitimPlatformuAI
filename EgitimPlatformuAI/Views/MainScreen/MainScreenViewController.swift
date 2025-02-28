//
//  ViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.01.2025.
//
import UIKit

class MainScreenViewController: UIViewController {
    @IBOutlet weak var nameContainerView: CustomNameContainer!
    var viewModel: MainScreenViewModel?

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.setNavigateBar()
        nameContainerView.configureView(nameLabel: "emirhanaydin_1600@hotmail.com", statusLabel: "Online", image: "person.fill")
    }
}


    
