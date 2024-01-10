import CropViewController
import UIKit

class ImageEditorView: UIViewController, CropViewControllerDelegate {
    var imageToEdit: UIImage?
    var idVM: idCaptureViewModel?
    var customNavController: AppViewModel?
    private var loadingVC: LoadingViewController?
    var onEditingDone: ((UIImage?) -> Void)?
    var onEditingCancelled: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let image = imageToEdit {
            DispatchQueue.main.async {
                
                let cropViewController = CropViewController(croppingStyle: .default, image: image)
                cropViewController.aspectRatioPreset = .presetSquare
                cropViewController.aspectRatioLockEnabled = false
                cropViewController.toolbarPosition = .top
                cropViewController.doneButtonTitle = "Done"
                cropViewController.doneButtonColor = .systemBlue
                cropViewController.cancelButtonTitle = "Cancel"
                cropViewController.cancelButtonColor = .systemRed
                cropViewController.delegate = self
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
        self.onEditingCancelled?()
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.idVM?.editedImage = image  // Update the shared model directly here
            self.onEditingDone?(image) // Pass the cropped image to the closure
            self.customNavController?.currentView = .pinMethod
            self.customNavController?.showLoad = true
            self.showLoadingScreen()
        }
    }
    
    func showLoadingScreen() {
        loadingVC = LoadingViewController()
        
        // Present it over the current context
        loadingVC?.modalPresentationStyle = .overCurrentContext
        loadingVC?.modalTransitionStyle = .crossDissolve
        
        if let loadingVC = loadingVC {
            present(loadingVC, animated: true) {
                // Dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismissLoadingScreen()
                }
            }
        }
    }
    
    func dismissLoadingScreen() {
        loadingVC?.dismiss(animated: true, completion: nil)
    }
}

