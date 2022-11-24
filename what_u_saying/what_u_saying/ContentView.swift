//
//  ContentView.swift
//  what_u_saying
//
//  Created by XYI on 24/11/2022.
//

//step 1
import Speech
import SwiftUI
import AVFoundation

//step 2
struct ButtonLabel: View {
    private let title: String
    private let background: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Spacer()
        }.padding().background(background).cornerRadius(10)
    }
    
    init(_ title: String, background: Color) {
        self.title = title
        self.background = background
    }
}


struct ContentView: View {
    
    //step 4
    @State var recording: Bool = false
    @State var speech: String = ""
    
    //extra step 2
    var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    if !speech.isEmpty {
                        Text(speech)
                            .font(.largeTitle)
                            .lineLimit(nil)
                    } else {
                        Text("Speech will go here...")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                    }

                    Spacer()

                    if recording {
                        Button(action: stopRecording) {
                            ButtonLabel("Stop Recording", background: .red)
                        }
                    } else {
                        Button(action: startRecording) {
                            ButtonLabel("Start Recording", background: .blue)
                        }
                    }
                }.padding()
                .navigationBarTitle(Text("woo hoo speech recogniser!!!"), displayMode: .inline)
            }
        }
    
    //step 5
    private let recognizer: SpeechRecognizer
    
    //step 6
    init() {
        guard let recognizer = SpeechRecognizer() else {
            fatalError("Something went wrong...")
        }
        self.recognizer = recognizer
    }
    
    //step 7
    private func startRecording() {
        self.recording = true
        self.speech = ""
        
        recognizer.startRecording { result in
            if let text = result {
                self.speech = text
            } else {
                self.stopRecording()
            }
        }
    }
    
    //step 8
    private func stopRecording() {
        self.recording = false
        recognizer.stopRecording()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
