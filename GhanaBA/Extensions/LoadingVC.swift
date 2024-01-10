import SwiftUI
import UIKit

// First, wrap the UIKit view controller in a SwiftUI view
struct LoadingViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoadingViewController {
        LoadingViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {
        // Leave this empty as there's no need to update the view controller in this scenario
    }
}

// Then, define the UIKit view controller as you have it
class LoadingViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.frame = UIScreen.main.bounds
        let customGreen = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        spinner.color = customGreen

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = customGreen
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        spinner.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
}

// Finally, create a SwiftUI preview for the LoadingViewRepresentable
struct LoadingViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        LoadingViewRepresentable()
    }
}

