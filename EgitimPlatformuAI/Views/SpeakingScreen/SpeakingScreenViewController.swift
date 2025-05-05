//
//  SpeakingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit


final class SpeakingScreenViewController: UIViewController {
    var viewModel: SpeakingScreenViewModel?
    private let recognizer = SpeechRecognizerManager()
   private let resultLabel = UILabel()
   private let micButton = UIButton(type: .system)
   private var isRecording = false
   
   let textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()

                recognizer.onTextRecognition = { [weak self] text in
                    self?.resultLabel.text = text
                }

                recognizer.requestPermissions { granted in
                    if !granted {
                        print("Kullanıcı izin vermedi.")
                    }
                }
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupUI() {
            view.backgroundColor = .systemBackground
            
            resultLabel.text = "Burada sesiniz yazıya dönüşecek..."
            resultLabel.font = .systemFont(ofSize: 18)
            resultLabel.numberOfLines = 0
            resultLabel.textAlignment = .center
            
            micButton.setTitle("🎤 Konuş", for: .normal)
            micButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            micButton.addTarget(self, action: #selector(micTapped), for: .touchUpInside)

            [resultLabel, micButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }

            NSLayoutConstraint.activate([
                resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
                resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                micButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 24),
                micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        @objc private func micTapped() {
            if isRecording {
                recognizer.stopRecording()
                micButton.setTitle("🎤 Konuş", for: .normal)
            } else {
                do {
                    try recognizer.startRecording()
                    micButton.setTitle("⏹️ Durdur", for: .normal)
                } catch {
                    print("Kayıt başlatılamadı: \(error)")
                }
            }
            isRecording.toggle()
        }
}
