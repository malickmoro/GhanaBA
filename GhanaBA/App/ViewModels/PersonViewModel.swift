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
    let success: Bool?
    let code: String
    let subcode: String?
    let msg: String
    let data: DataResponse?
}

struct DataResponse: Codable {
    let shortGuid: String?
    let person: Person?
}

struct Person: Codable {
    let surname: String?
    let forenames: String?
    let biometricFeed: BiometricFeed?
}

struct BiometricFeed: Codable {
    let face: Face?

}

struct Face: Codable {
    let dataType: String?
    let data: String?
}

class PersonViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var generatedID: String = ""
    @Published var editedImage: UIImage?
    @Published var mrzNumber: String = ""
    @Published var apiResponse: ApiResponse?
    
    @Published var showResponseView: Bool = false
    @Published var rawResponseString: String?
    @Published var showAlert = false
    @Published var alertTitle = "Error"
    @Published var alertMessage = ""
    
    //from the ID API
    @Published var responseCode: String?
    @Published var responseMessage: String = ""
    @Published var successValue: Bool?
    @Published var shortGuid: String?
    @Published var faceImage: UIImage?
    @Published var forename: String?
    @Published var surname: String?
    
    func printRequest(_ request: URLRequest) {
        var requestDetails = ""

        if let url = request.url?.absoluteString {
            print("URL: \(url)")
            requestDetails += "URL: \(url)\n"
        }
        if let method = request.httpMethod {
            print("Method: \(method)")
            requestDetails += "Method: \(method)\n"
        }
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
            requestDetails += "Headers: \(headers)\n"
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
            requestDetails += "Body: \(bodyString)\n"
        }

        // Write to file
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("output2.txt")
            
            do {
                try requestDetails.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Successfully written to \(fileURL)")
            } catch {
                print("Error writing to file: \(error)")
            }
        }
    }

    
    func verifyIDAndImage(completion: @escaping (Bool) -> Void) {
        isLoading = true  // Start loading
        guard let image = editedImage else { return }
        
        let pngImg = image.jpegData(compressionQuality: 1 )
        
//        if let base64String = pngImg?.base64EncodedString() { writeToFile(base64String: base64String, fileName: "output") }
        
        let base64String = pngImg!.base64EncodedString()
        let url = URL(string: "https://selfie.imsgh.org:2035/skyface/api/v1/third-party/verification/base_64")!
        let pin = self.generatedID
        let merchant_code = "69af98f5-39fb-44e6-81c7-5e496328cc59"
        let center = "BRANCHLESS"
        let datatype = "PNG"
        
        let json: [String: Any] = [
            "pinNumber": pin,
            "image": base64String,
            "dataType": datatype,
            "center": center,
            "merchantKey": merchant_code
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            print("Error creating JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        printRequest(request)

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
                    print(httpResponse.statusCode)
                    if let data = data {
                        do {
                            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                            self?.apiResponse = decodedResponse
                            self?.parseApiResponse(data: data)
                            if decodedResponse.data?.person?.forenames != nil {
                                
                                completion(decodedResponse.success!)
                            } else {
                                self?.alertTitle = "WRONG INFORMATION"
                                self?.alertMessage = "Face and Pin Does not match"
                                self?.showAlert = true
                                completion(false)  // Ensure completion is called
                            }
                            print(decodedResponse)
                        } catch {
                            self?.handleDecodingError(error)
                            completion(false)  // Ensure completion is called
                        }
                    } else {
                        self?.alertTitle = "NO DATA"
                        self?.alertMessage = "No data received from server"
                        self?.showAlert = true
                        completion(false)  // Ensure completion is called
                    }
                } else {
                    print(httpResponse.statusCode)
                    self?.handleServerError(info: data)
                    completion(false)  // Ensure completion is called
                }
            }
        }.resume()
    }
    
    func verifyMRZandImage(completion: @escaping (Bool) -> Void){
        isLoading = true  // Start loading
        guard let image = editedImage else { return }
        
        let pngImg = image.jpegData(compressionQuality: 1 )
        
        //        if let base64String = pngImg?.base64EncodedString() { writeToFile(base64String: base64String, fileName: "output") }
        
        let base64String = pngImg!.base64EncodedString()
        let url = URL(string: "https://selfie.imsgh.org:2035/skyface/api/v1/third-party/ghpay/verification/with_doc_number/base_64")!
        let mrz = self.mrzNumber
        let merchant_code = "69af98f5-39fb-44e6-81c7-5e496328cc59"
        let center = "BRANCHLESS"
        let datatype = "PNG"
        
        let json: [String: Any] = [
            "pinNumber": mrz,
            "image": base64String,
            "dataType": datatype,
            "center": center,
            "merchantKey": merchant_code
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            print("Error creating JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        printRequest(request)
        
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
                    print(httpResponse.statusCode)
                    if let data = data {
                        do {
                            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                            self?.apiResponse = decodedResponse
                            self?.parseApiResponse(data: data)
                            if decodedResponse.data?.person?.forenames != nil {
                                completion(decodedResponse.success!)
                            } else {
                                self?.alertTitle = "WRONG INFORMATION"
                                self?.alertMessage = "Face and Pin Does not match"
                                self?.showAlert = true
                                completion(false)  // Ensure completion is called
                            }
                            print(decodedResponse)
                        } catch {
                            self?.handleDecodingError(error)
                            completion(false)  // Ensure completion is called
                        }
                    } else {
                        self?.alertTitle = "NO DATA"
                        self?.alertMessage = "No data received from server"
                        self?.showAlert = true
                        completion(false)  // Ensure completion is called
                    }
                } else {
                    print(httpResponse.statusCode)
                    self?.handleServerError(info: data)
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
    
    
    private func handleServerError(info: Data?) {
        guard let data = info else {
            print("Error: No data to decode")
            alertMessage = "No data available"
            return
        }
        
        do {
            let game = try JSONDecoder().decode(ApiResponse.self, from: data)
            apiResponse = game
            alertMessage = game.msg
            print("Server returned an error: \(game)")
        } catch {
            print("JSON Decoding Error: \(error)")
            alertMessage = "Decoding error: \(error.localizedDescription)"
        }
    }
    
    
    
    func parseApiResponse(data: Data) {
        do {
            let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            // Extract and store data into strings
            self.responseCode = decodedResponse.code
            self.responseMessage = decodedResponse.msg
            self.successValue = decodedResponse.success
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
}

extension PersonViewModel {
    var fullName: String {
        return "\(forename ?? "") \(surname ?? "")"
    }
    
    func writeToFile(base64String: String, fileName: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName + ".txt")
            
            do {
                try base64String.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Successfully written to \(fileURL)")
            } catch {
                print("Error writing to file: \(error)")
            }
        }
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
        responseMessage = ""
        successValue = nil
        shortGuid = nil
        faceImage = nil  // UIImage properties are optional, so set to nil
        forename = nil
        surname = nil
    }
}


