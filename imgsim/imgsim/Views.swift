//
//  Views.swift
//  imgsim
//
//  Created by XYI on 22/11/2022.
//

//step2
import SwiftUI

//step3
struct OptionalResizableImage: View {
    let image: UIImage?
    let placeholder: UIImage

    var body: some View {
        if let image = image {
            return Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            return Image(uiImage: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

//step4
struct ButtonLabel: View {
    private let text: String
    private let background: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(text).font(.title).bold().foregroundColor(.white)
            Spacer()
        }.padding().background(background).cornerRadius(10)
    }
    
    init(_ text: String, background: Color) {
        self.text = text
        self.background = background
    }
}

//step5
struct ImagePickerView: View {
    private let completion: (UIImage?) -> ()
    private let camera: Bool

    var body: some View {
        ImagePickerControllerWrapper(
            camera: camera,
            completion: completion
        )
    }

    init(camera: Bool = false, completion: @escaping (UIImage?) -> ()) {
        self.completion = completion
        self.camera = camera
    }
}

//step6
struct ImagePickerControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    private(set) var selectedImage: UIImage?
    private(set) var cameraSource: Bool
    private let completion: (UIImage?) -> ()

    init(camera: Bool, completion: @escaping (UIImage?) -> ()) {
        self.cameraSource = camera
        self.completion = completion
    }

    func makeCoordinator() -> ImagePickerControllerWrapper.Coordinator {
        let coordinator = Coordinator(self)
        coordinator.completion = self.completion
        return coordinator}
    
    func makeUIViewController(context: Context) ->
        UIImagePickerController {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType =
            cameraSource ? .camera : .photoLibrary
        return imagePickerController
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController, context: Context) {
        //uiViewController.setViewControllers(?, animated: true)
    }
//step6
    class Coordinator: NSObject,
        UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePickerControllerWrapper
        var completion: ((UIImage?) -> ())?

        init(_ imagePickerControllerWrapper:
            ImagePickerControllerWrapper) {
            self.parent = imagePickerControllerWrapper
        }

        func imagePickerController(_ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
                [UIImagePickerController.InfoKey: Any]) {

            print("Image picker complete...")
            let selectedImage =
                info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage
            picker.dismiss(animated: true)
            completion?(selectedImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            print("Image picker cancelled...")
            picker.dismiss(animated: true)
            completion?(nil)
        }
    }
}

//step7
extension UIImage {
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


