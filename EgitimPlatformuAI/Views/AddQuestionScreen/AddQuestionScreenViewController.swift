//
//  AddQuestionScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 9.06.2025.
//

import UIKit
import Foundation
import Lottie

final class AddQuestionScreenViewController: UIViewController{
    
    @IBOutlet var backButton: CustomBackButtonView!
    var viewModel: AddQuestionScreenViewModel!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func backButtonTapped(){
        print("back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    
    
}


