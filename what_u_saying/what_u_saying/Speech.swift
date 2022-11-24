//
//  Speech.swift
//  what_u_saying
//
//  Created by XYI on 24/11/2022.
//

//extra step 1
import Speech
import AVFoundation

//step 2
class SpeechRecognizer {
    //step 3
    private let audioEngine: AVAudioEngine
    private let session: AVAudioSession
    private let recognizer: SFSpeechRecognizer
    
    private let inputBus: AVAudioNodeBus
    private let inputNode: AVAudioInputNode
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var permissions: Bool = false
    
    //step 4
    init?(inputBus: AVAudioNodeBus = 0) {
        self.audioEngine = AVAudioEngine()
        self.session = AVAudioSession.sharedInstance()
        
        guard let recognizer = SFSpeechRecognizer() else { return nil }
        
        self.recognizer = recognizer
        self.inputBus = inputBus
        self.inputNode = audioEngine.inputNode
    }
    
    //step 5
    func checkSessionPermissions(_ session: AVAudioSession,
                                 completion: @escaping (Bool) -> ()) {
        
        if session.responds(
            to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            session.requestRecordPermission(completion)
        }
    }
    
    //step 6
    func startRecording(completion: @escaping (String?) -> ()) {
        audioEngine.prepare()
        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        
        // step 7: check audio/microphone access permissions
        checkSessionPermissions(session) {
            success in self.permissions = success
        }
        
        guard let _ = try? session.setCategory(
            .record,
            mode: .measurement,
            options: .duckOthers),
                  let _ = try? session.setActive(
                    true,
                    options: .notifyOthersOnDeactivation),
                  let _ = try? audioEngine.start(),
                  let request = self.request
        else {
            return completion(nil)
        }
        
        //step 8
        let recordingFormat = inputNode.outputFormat(forBus: inputBus)
        inputNode.installTap(
            onBus: inputBus,
            bufferSize: 1024,
            format: recordingFormat) {
                (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.request?.append(buffer)
            }
        
        //step 9
        print("Started recording...")
        
        //step 10
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                print("Heard: \"\(transcript)\"")
                completion(transcript)
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
                completion(nil)
            }
        }
    }
    
    
    //step 11
    func stopRecording() {
        print("...stopped recording.")
        request?.endAudio()
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        request = nil
        task = nil
    }
    
    
}




