//
//  ProfileScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 16.01.2025.
//

import UIKit
class ProfileScreenViewController: UIViewController {

    var viewModel: ProfileScreenViewModel?

    init(viewModel: ProfileScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
