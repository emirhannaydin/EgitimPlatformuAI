//
//  ListeningScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class ListeningScreenViewController: UIViewController {
    var viewModel: ListeningScreenViewModel?
    
    @IBOutlet var backButton: CustomBackButtonView!
    var tts: TextToSpeech = TextToSpeech()
    var label = "Selamlar, nasılsın?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Listening"
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        tts.speak(text:label)
        tts.startSpeaking()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
   
}
