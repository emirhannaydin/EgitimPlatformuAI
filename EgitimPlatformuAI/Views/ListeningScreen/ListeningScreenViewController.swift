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
    
    var tts: TextToSpeech = TextToSpeech()
    var label = "Selamlar, nasılsın?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        tts.speak(text:label)
        tts.startSpeaking()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
}
