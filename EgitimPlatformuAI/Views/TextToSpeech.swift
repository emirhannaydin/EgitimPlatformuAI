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
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
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
