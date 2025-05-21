//
//  TextToSpeech.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 30.04.2025.
//

import UIKit
import AVFoundation
class TextToSpeech {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        
        // Konuşma özellikleri
        utterance.rate = 0.5             // Konuşma hızı
        utterance.pitchMultiplier = 1.2   // Sesin tınısı (biraz daha ince ses)
        utterance.volume = 1.0            // Ses yüksekliği

        synthesizer.speak(utterance)
    }

    
    func startSpeaking(){
        synthesizer.continueSpeaking()
    }
    
    func stopSpeaking(){
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func pauseSpeaking(){
        synthesizer.pauseSpeaking(at: .immediate)
    }
}
