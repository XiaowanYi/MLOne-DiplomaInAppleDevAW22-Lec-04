//
//  ContentView.swift
//  imgsim
//
//  Created by XYI on 22/11/2022.
//

import SwiftUI


struct ContentView: View {
    //step1
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false

    @State private var firstImage: UIImage? = nil
    @State private var secondImage: UIImage? = nil
    @State private var similarity: Int = -1

    //step2
    private let placeholderImage = UIImage(named: "placeholder")!

    private var cameraEnabled: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    private var selectEnabled: Bool {
        secondImage == nil
    }

    private var comparisonEnabled: Bool {
        secondImage != nil && similarity < 0
    }
    
    //step8
    var body: some View {
            if imagePickerOpen {
                return  AnyView(ImagePickerView { result in
                    self.controlReturned(image: result)
                    self.imagePickerOpen = false
                })
            } else if cameraOpen {
                return  AnyView(ImagePickerView(camera: true) { result in
                    self.controlReturned(image: result)
                    self.cameraOpen = false
                })
            } else {
                return AnyView(NavigationView {
                    VStack {
                        HStack {
                            OptionalResizableImage(image: firstImage, placeholder: placeholderImage)
                            OptionalResizableImage(image: secondImage, placeholder: placeholderImage)
                        }
                        
                        Button(action: clearImages) { Text("Clear Images") }
                        Spacer()
                        Text("Similarity: \(similarity > 0 ? String(similarity) : "...")%").font(.title).bold()
                        Spacer()
                        
                        if comparisonEnabled {
                            Button(action: getSimilarity) {
                                ButtonLabel("Compare", background: .blue)
                            }.disabled(!comparisonEnabled)
                        } else {
                            Button(action: getSimilarity) {
                                ButtonLabel("Compare", background: .gray)
                            }.disabled(!comparisonEnabled)
                        }
                    }.padding().navigationBarTitle(Text("ISDemo"), displayMode: .inline)
                    .navigationBarItems(leading: Button(action: summonImagePicker) { Text("Select") }.disabled(!selectEnabled),
                        trailing: Button(action: summonCamera) { Image(systemName: "camera") }.disabled(!cameraEnabled))
                })
            }
        }
    
    //step3
    private func clearImages() {
        firstImage = nil
        secondImage = nil
        similarity = -1
    }
    
    //step4
    private func getSimilarity() {
        print("Getting similarity...")
        if let firstImage = firstImage, let secondImage = secondImage,
            let similarityMeasure = firstImage.similarity(to: secondImage){
            similarity = Int(similarityMeasure)
        } else {
            similarity = 0
        }
        print("Similarity: \(similarity)%")
    }
    
    //step5
    private func controlReturned(image: UIImage?) {
            print("Image return \(image == nil ? "failure" : "success")...")
            if firstImage == nil {
                firstImage = image?.fixOrientation()
            } else {
                secondImage = image?.fixOrientation()
            }
        }
    
    //step6
    private func summonImagePicker() {
        print("Summoning ImagePicker...")
        imagePickerOpen = true
    }
      
    //step7
    private func summonCamera() {
        print("Summoning camera...")
        cameraOpen = true
    }
    


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
