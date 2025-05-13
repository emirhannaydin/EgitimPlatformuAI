//
//  SpeakingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import UIKit
import AVFoundation

final class SpeakingScreenViewController: UIViewController {
    
    var viewModel: SpeakingScreenViewModel!

    private let recorder = AudioRecorderManager()
    private let micButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let targetTextLabel = UILabel()
    
    private let targetText = "Ben bugün sinemaya gittim."
    
    private var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        targetTextLabel.text = "Lütfen şu metni okuyun:\n\n\(targetText)"
        targetTextLabel.font = .systemFont(ofSize: 18, weight: .medium)
        targetTextLabel.textAlignment = .center
        targetTextLabel.numberOfLines = 0
        
        resultLabel.text = "Sonuç burada görünecek"
        resultLabel.font = .systemFont(ofSize: 16)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        
        micButton.setTitle("🎤 Kaydı Başlat", for: .normal)
        micButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        micButton.addTarget(self, action: #selector(micTapped), for: .touchUpInside)
        
        [targetTextLabel, resultLabel, micButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            targetTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            targetTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            targetTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            resultLabel.topAnchor.constraint(equalTo: targetTextLabel.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            micButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 40),
            micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func micTapped() {
        if isRecording {
            recorder.stopRecording()
            micButton.setTitle("🎤 Kaydı Başlat", for: .normal)
            isRecording = false
            
            guard let url = recorder.getAudioFileURL() else { return }
            
            Task {
                await handleTranscription(for: url)
            }
        } else {
            do {
                try recorder.startRecording()
                micButton.setTitle("⏹️ Kaydı Durdur", for: .normal)
                isRecording = true
            } catch {
                print("❌ Kayıt başlatılamadı: \(error)")
            }
        }
    }
    
    private func handleTranscription(for url: URL) async {
        DispatchQueue.main.async {
            self.resultLabel.text = "⏳ Transkripsiyon yapılıyor..."
        }
        
        if let result = await AIAPIManager.shared.transcribeWhisperManually(audioURL: url, expectedText: targetText) {
            let score = Int(result.accuracy * 100)
            let color: UIColor = score >= 85 ? .systemGreen : score >= 60 ? .systemOrange : .systemRed
            
            DispatchQueue.main.async {
                self.resultLabel.text = """
                🗣️ Algılanan Metin: \(result.transcribedText)

                🎯 Doğruluk: %\(score)
                """
                self.resultLabel.textColor = color
            }
        } else {
            DispatchQueue.main.async {
                self.resultLabel.text = "❌ Transkripsiyon yapılamadı."
                self.resultLabel.textColor = .systemRed
            }
        }
    }
}
