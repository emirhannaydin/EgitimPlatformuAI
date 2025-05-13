//
//  AudioRecorderManager.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 10.05.2025.
//

import AVFoundation

final class AudioRecorderManager {
    private var audioRecorder: AVAudioRecorder?
    private var audioFilename: URL?

    func startRecording() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let fileName = UUID().uuidString + ".m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioFilename = documentsPath.appendingPathComponent(fileName)

        audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
        audioRecorder?.record()
    }

    func stopRecording() {
        audioRecorder?.stop()
        print(audioFilename?.path)
    }

    func getAudioFileURL() -> URL? {
        return audioFilename
    }
}
