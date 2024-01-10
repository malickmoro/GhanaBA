import UIKit
import SwiftUI
import AVFoundation

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    var onEditingCancelled: (() -> Void)?
    var onEditingDone: (() -> Void)?
    var userVM: UserViewModel!
 //   var customNavController: AppViewModel?
    
    private let shutterButton = SwiftyCamButton()
    private let flipCameraButton = UIButton(type: .custom)
    private let flashButton = UIButton(type: .custom)
    private let toolbarView = UIView()
    let photoSettings = AVCapturePhotoSettings()


    init(userVM: UserViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.userVM = userVM
   //     self.customNavController = customNavController
        // Setup SwiftyCam delegate
        self.cameraDelegate = self
        // Additional SwiftyCam configurations
        self.shouldPrompToAppSettings = true
        self.shouldUseDeviceOrientation = true
        self.allowBackgroundAudio = true
        self.doubleTapCameraSwitch = true
        self.flashMode = .off
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupToolbarView()
        setupButtons()

    }

    
    private func setupToolbarView() {
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarView)
        NSLayoutConstraint.activate([
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            toolbarView.heightAnchor.constraint(equalToConstant: 200) // Or your desired height
        ])
        toolbarView.backgroundColor = UIColor.black.withAlphaComponent(1)
        
        
    }

    private func setupButtons() {

        setupShutterButton()
        setupFlipCameraButton()
        setupFlashButton()
    }


    private func setupShutterButton() {
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shutterButton)
        shutterButton.backgroundColor = .white
        shutterButton.layer.cornerRadius = 35
        shutterButton.delegate = self
        
        NSLayoutConstraint.activate([
               shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               shutterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
               shutterButton.widthAnchor.constraint(equalToConstant: 70),
               shutterButton.heightAnchor.constraint(equalToConstant: 70)
           ])
    }
    
    
    
    private func setupFlipCameraButton() {
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flipCameraButton)
        flipCameraButton.setImage(UIImage(named: "flipCamera"), for: .normal) // Replace with your image
        
        NSLayoutConstraint.activate([
            flipCameraButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            flipCameraButton.trailingAnchor.constraint(equalTo: shutterButton.leadingAnchor, constant: -70),
            flipCameraButton.widthAnchor.constraint(equalToConstant: 50),
            flipCameraButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        flipCameraButton.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)
    }
        
    private func setupFlashButton() {
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flashButton)
        flashButton.imageView?.contentMode = .scaleAspectFit
        flashButton.setImage(UIImage(named: "flash"), for: .selected) // Replace with your images
        flashButton.setImage(UIImage(named: "flashOutline"), for: .normal)
        
        NSLayoutConstraint.activate([
            flashButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            flashButton.leadingAnchor.constraint(equalTo: shutterButton.trailingAnchor, constant: 70),
            flashButton.widthAnchor.constraint(equalToConstant: 50),
            flashButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
    }
    
    
    
    private func setupToolbar() {
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarView)
        NSLayoutConstraint.activate([
            toolbarView.heightAnchor.constraint(equalToConstant: 100), // Adjust the height as needed
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


    func swiftyCamButtonDidTakePhoto() {
        // This method will be called when the photo is taken
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Handle the captured photo
        presentImageEditor(with: photo)
    }


    @objc private func flipCamera() {
        switchCamera()
    }


    @objc private func toggleFlash() {
        if flashMode == .off {
            flashMode = .on
            flashButton.isSelected = true
        } else {
            flashMode = .off
            flashButton.isSelected = false
        }
        // Update the flash mode of your camera session here
    }

    func presentImageEditor(with photo: UIImage) {
        let editorVC = ImageEditorView()
        editorVC.imageToEdit = photo
        editorVC.userVM = self.userVM
        editorVC.modalPresentationStyle = .fullScreen
        editorVC.onEditingDone = { [weak self] editedImage in
            guard let self = self, let editedImage = editedImage else { return }
            self.userVM.editedImage = editedImage
            self.onEditingDone?()
        }
        editorVC.onEditingCancelled = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        self.present(editorVC, animated: true, completion: nil)
    }

    
}
