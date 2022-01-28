//
//  ImagesNetworking.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import Alamofire

// MARK: - Images Router ENUM

/// The Images ENUM is responsible for constructing the server requests
public enum ImagesRouter {
    /// The Images GET request
    case getImages
}

// MARK: - Images Constants

/// The Images Constants used only within the Alarm Router ENUM.
private struct ImagesConstants {
    // Scheme
    static let scheme = "https"
    
    // Host
    static let host = "jsonplaceholder.typicode.com"

    // Endpoint Path
    static let path = "/album/1/photos"
}

// MARK: - Images Router Extension

extension ImagesRouter: EndPointType {
    
    /// The scheme consists of the first part of the URL request.
    public var scheme: String {
        switch self {
        case .getImages:
            return ImagesConstants.scheme
        }
    }

    /// The Host consists of the general  URL
    public var host: String {
        switch self {
        case .getImages:
            return ImagesConstants.host.removingPercentEncoding ?? ""
        }
    }
    
    /// The Path consists of the specific endpoint to reach out to
    public var path: String {
        switch self {
        case .getImages:
            return ImagesConstants.path
        }
    }

    /// The Query Items consist of the specific values to send to the server dependant on which case is declared.
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .getImages:
            return nil
        }
    }

    /// The Method consists of which type of server request is needed dependant on which case is declared.
    public var method: HTTPMethod {
        switch self {
        case .getImages:
            return .get
        }
    }

    /// The Body consists of the JSON Data to be passed to the server.
    public var httpBody: [String: Any]? {
        return nil
    }

    /// The Headers consist of any information that is needed to be passed along to the server.
    public var headers: HTTPHeaders {
        return [:]
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

public class ImagesNetworking: Networking {

}

extension Networking {
    
    // MARK: - Images Request

    /// This class function will initiate a GET request to the "/album/1/photos" endpoint to retrieve a list Images and their details
    ///
    /// - Parameters:
    ///   - completion: The completion handler that will be called once a Success or Failure is received from the Backend response.
    ///   - result: The JSON result received from the Backend.
    ///   - status: The response status.
    public class func getImages(_ completion: @escaping (_ result: Any?, _ status: ResultStatus) -> ()) {
        let endpoint = ImagesRouter.getImages

        self.genericRequest(with: endpoint) { data, result in
            switch result {
            case .success:
                
                do {
//                    // Pretty Printed format for the server response
//                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
//                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
//                        print(String(decoding: jsonData, as: UTF8.self))
//                    } else {
//                        print("json data malformed")
//                    }
                    
                    if let imagesData = data {
                        let stackOverflowUsers = try JSONDecoder().decode([Images].self, from: imagesData)
                        print("Networking Line# \(#line) - Successfully decoded the Images data)")
                        completion(stackOverflowUsers, .success)
                    } else {
                        print("Networking Line# \(#line) - The Images data is nil")
                        completion(data, .error)
                    }
                } catch {
                    print("Networking Line# \(#line) - There was an error decoding the Images data: \(error.localizedDescription)")
                    completion(nil, .error)
                }
                
            case .failure:
                completion(data, .failure)
            case .error:
                completion(data, .error)
            }
        }
    }
}
