/*
See LICENSE folder for this sample’s licensing information.
*/

import AVFoundation
import Foundation
import SwiftUI

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class PingRecorder: ObservableObject {
    enum RecorderError: Error {
        case nilRecognizer
        case notPermittedToRecord
        case fileFormatError
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .fileFormatError: return "Problem with the file format"
            }
        }
    }
    
    private var audioEngine: AVAudioEngine?
    private var recordedFileURL = URL(fileURLWithPath: "input.caf", isDirectory: false, relativeTo: URL(fileURLWithPath: NSTemporaryDirectory()))
    private var recordedFile: AVAudioFile?
    private var recordedFileFormat: AVAudioFormat?
    private var isNewRecordingAvailable = false

    public private(set) var isRecording = false
//    public private(set) var voiceIOFormat: AVAudioFormat

    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init() {
        print("Record file URL: \(recordedFileURL.absoluteString)")
        
        Task(priority: .background) {
            do {
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecorderError.notPermittedToRecord
                }
            } catch {
                // speakError(error)
                // do error stuff
            }
        }
    }
    
    deinit {
        reset()
    }

    func toggleRecording() {
        if isRecording {
            isRecording = false
            recordedFile = nil // Close the file.
        } else {
            do {
                if let settings = recordedFileFormat?.settings {
                    recordedFile = try AVAudioFile(forWriting: recordedFileURL, settings: settings)
                    isNewRecordingAvailable = true
                    isRecording = true
                }
            } catch {
                print("Could not create file for recording: \(error)")
            }
        }
    }

    func recordPing() {
    // Finish this later
          
//        let engine = AVAudioEngine()

    }

    /// Reset the audio engine
    func reset() {
        audioEngine?.stop()
        audioEngine = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine) {
        let audioEngine = AVAudioEngine()
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
//        let outputNode = audioEngine.outputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            do {
//                try self.recordedFile?.write(from: buffer)
//            } catch {
//                print("Could not write buffer: \(error)")
            }
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine)
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecorderError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
//        transcript = "<< \(errorMessage) >>"
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
