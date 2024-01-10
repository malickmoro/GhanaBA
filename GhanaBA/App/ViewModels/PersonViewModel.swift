//
//  PersonViewModel.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import Foundation
import UIKit

// Define structs to match the JSON structure
struct ApiResponse: Codable {
    let found: Bool
    let code: String
    let msg: String
    let status: String
    let data: DataResponse?
}

struct DataResponse: Codable {
    let shortGuid: String
    let person: Person?
}

struct Person: Codable {
    let surname: String
    let forenames: String
    let biometricFeed: BiometricFeed?
}

struct BiometricFeed: Codable {
    let face: Face?

}

struct Face: Codable {
    let dataType: String
    let data: String
}

class PersonViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var generatedID: String = ""
    @Published var editedImage: UIImage?
    @Published var apiResponse: ApiResponse?
    
    @Published var showResponseView: Bool = false
    @Published var rawResponseString: String?
    @Published var showAlert = false
    @Published var alertTitle = "Error"
    @Published var alertMessage = ""
    
    //from the ID API
    @Published var responseCode: String?
    @Published var responseMessage: String?
    @Published var successValue: Bool?
    @Published var shortGuid: String?
    @Published var faceImage: UIImage?
    @Published var forename: String?
    @Published var surname: String?
    
    func verifyIDAndImage(completion: @escaping (Bool) -> Void) {
        isLoading = true  // Start loading
        guard let image = editedImage else { return }
        
        let pngImg = image.jpegData(compressionQuality: 0.4)?.pngFromJPEG
        
        // Generate boundary string using a unique per-app string
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let url = URL(string: "https://selfie.imsgh.org:2035/skyface/api/v1/third-party/verification/form_data")!
        let merchant_code = "69af98f5-39fb-44e6-81c7-5e496328cc59"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Function to append text to the body
        func append(_ value: String, withName name: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append the pinNumber part
        append(self.generatedID, withName: "pin")
        
        // Append the image part
        if let imageData = pngImg {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Append the merchantKey part
        append(merchant_code, withName: "merchant_code")
        
        
        // End of the body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the body on the request
        request.httpBody = body
        
        // Start the data task
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                defer { self?.isLoading = false }  // Ensure isLoading is set to false when exiting the block
                
                if let error = error {
                    self?.handleNetworkError(error)
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.alertTitle = "Error"
                    self?.alertMessage = "Invalid response from server."
                    self?.showAlert = true
                    completion(false)  // Ensure completion is called
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        do {
                            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                            self?.apiResponse = decodedResponse
                            completion(decodedResponse.found)
                            print(decodedResponse)
                            
                        } catch {
                            self?.handleDecodingError(error)
                            completion(false)  // Ensure completion is called
                        }
                    } else {
                        self?.alertTitle = "NO DATA"
                        self?.alertMessage = "No data reciewved from server"
                        self?.showAlert = true
                        completion(false)  // Ensure completion is called
                    }
                } else {
                    self?.handleServerError(statusCode: httpResponse.statusCode, data: data)
                    completion(false)  // Ensure completion is called
                }
            }
        }.resume()
    }
    
    private func handleNetworkError(_ error: Error) {
        alertTitle = "Network Error"
        alertMessage = error.localizedDescription
        showAlert = true
    }

    private func handleDecodingError(_ error: Error) {
        print("yolo")
        alertTitle = "Decoding Error"
        alertMessage = "There was an error processing the server's response. Please try again later."
        showAlert = true
    }

    private func handleServerError(statusCode: Int, data: Data?) {
        alertTitle = "Server Error"
        alertMessage = "The server encountered an error. Please try again later."
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Server returned an error: \(responseString)")
        }
        showAlert = true
    }
    
    func parseApiResponse(data: Data) {
        do {
            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            // Extract and store data into strings
            self.responseCode = decodedResponse.code
            self.responseMessage = decodedResponse.msg
            self.successValue = decodedResponse.found
            // Extract values from `DataResponse`
            if let dataResponse = decodedResponse.data {
                self.shortGuid = dataResponse.shortGuid
                // Extract values from `Person`
                if let person = dataResponse.person {
                    self.forename = person.forenames
                    self.surname = person.surname
                    // Handle biometric feed
                    if let biometricFeed = person.biometricFeed,
                       let biometricData = biometricFeed.face?.data,
                       let faceData = Data(base64Encoded: biometricData) {
                        self.faceImage = UIImage(data: faceData)
                    }
                }
            }
        } catch {
            print("Error decoding response: \(error)")
        }
    }
    
    
    
    func formattedResponse() -> String {
        let code = responseCode ?? ""
        let message = responseMessage ?? ""
        let success = successValue
        return "Code: \(code)\nMessage: \(message) \nSuccess: \(String(describing: success))"
    }

    
}

extension PersonViewModel {
    var fullName: String {
        return "\(forename ?? "") \(surname ?? "")"
    }
}

extension PersonViewModel: Resettable {
    func reset() {
        // Resetting boolean and string properties to their default states
        isLoading = false
        generatedID = ""
        editedImage = nil  // UIImage properties are optional, so set to nil
        apiResponse = nil  // Assuming nil is the initial state for ApiResponse
        showResponseView = false
        rawResponseString = nil

        
        // Resetting properties from the ID API
        responseCode = nil
        responseMessage = nil
        successValue = nil
        shortGuid = nil
        faceImage = nil  // UIImage properties are optional, so set to nil
        forename = nil
        surname = nil
    }
}


