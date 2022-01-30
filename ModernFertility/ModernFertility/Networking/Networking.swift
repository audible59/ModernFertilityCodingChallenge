//
//  Networking.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import Alamofire

/// This is the main Protocol that all Router classes will extend from.
public protocol EndPointType {
    /// The Scheme part of the URL consists of the very beginning (i.e. https://)
    var scheme: String { get }
    /// The Host part of the URL consists of the primary part (i.e. api-staging.getwheelsapp.com)
    var host: String { get }
    /// The Path part of the URL consists of the specific server endpoint to be reached (i.e. /v1/auth/phone/request)
    var path: String { get }
    /// The Query paramters that will be appended to the end of the URL
    var queryItems: [URLQueryItem]? { get }
    /// The payload that will be sent in the httpBody
    var httpBody: [String: Any]? { get }
    /// The type of request to send to the server (i.e. POST)
    var method: HTTPMethod { get }
    /// Data that will be sent in the httpBody
    /// The Headers to send along with the URL request
    var headers: HTTPHeaders { get }
    /// Whether the request should have an authentication header added to it or not
    var isAuthenticated: Bool { get }
}

public typealias HTTPHeaders = [String: String]

/// This ENUM represents the different statuses received from the Backend respones
public enum ResultStatus: Int {
    /// Success is when a successful response is received from the Bakcend.
    case success
    /// Failure is returned when a failure response is received from the Bakcend
    case failure
    /// Error is eturned when an Error response is received from the Bakcend.
    case error
}

/// This ENUM represents the different Error statuses received from the Backend respones
public enum WLNetworkingError: Error {
    case missingRequest
    case invalidJson
}

public class Networking: NSObject {
    
    // MARK: - Properties
    
    static let networkingQueue = DispatchQueue.global(qos: .background)
    
    // MARK: Custom Server Requests

    /// This class function will take a specified EndPointType object and perform the server request.
    ///
    /// Choose this performRequest option if you plan on handling the JSON serialization parsing on your own end.
    ///
    /// - Parameters:
    ///   - endpoint: The EndPointType object that constructs the entire URL request that will be sent to the server.
    ///   - completion: The completion handler that will return a result (if any) along with the server response status.
    ///   - result: The raw Data result received from the Backend that will be decoded by the callee.
    ///   - status: The response status.
    public class func genericRequest(with endpoint: EndPointType,
                                     completion: @escaping (_ result: Data?, _ status: ResultStatus) -> Void) {
        guard let request = endpoint.buildRequest() else {
            completion(nil, .failure)
            print("Networking Line# \(#line) - There was an error building the request for endpoint - \"\(endpoint.path)\"")
            return
        }
        
        AF.request(request)
            .logRequest()
            .validate(statusCode: 200..<299)
            .validate(contentType: ["application/json"])
            .responseData(queue: self.networkingQueue) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        completion(data, .success)
                    case .failure(let error):
                        print("Networking Line# \(#line) - There was an error retrieving the Stack Overflow users: \(error.localizedDescription)")
                        completion(nil, .error)
                    }
                }
        }
    }
}

extension DataRequest {
    /// This method will log the cUrl request for debugging purposes.
    fileprivate func logRequest() -> Self {
        print(debugPrint(self))
        return self
    }
}

extension EndPointType {
    /// The scheme consists of the first part of the URL request.
    public var scheme: String {
        return "https"
    }

    /// The Host consists of the general  URL dependant on the build environment.
    public var host: String {
        return "jsonplaceholder.typicode.com"
    }
    
    /// The Path consists of the specific endpoint to reach out to dependant on which case is declared.
    public var path: String {
        return "/album/1/photos"
    }

    /// The Headers consist of any information that is needed to be passed along to the server.
    public var headers: HTTPHeaders {
        return [:]
    }

    /// Whether the request should have an authentication header added to it or not
    public var isAuthenticated: Bool {
        return true
    }

    // MARK: - URL Request Construction

    /// This function will build out the server request and add the approriate headers
    public func buildRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard var url = components.url else { return nil }
        
        // Remove any encoding that should not exist
        var string = url.absoluteString
        string = string.removingPercentEncoding ?? ""
        url = URL(string: string)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // We don't need Time Zone
//        request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "X-COMPANY-TZ")
        
        // We don't need authentication
//        if isAuthenticated, let token = WLPersistenceUtil.loadUser()?.token {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        
        // We don't need location
//        if let location = WLUserLocationContinualManager.shared().location {
//            let geoPosition = "\(location.coordinate.latitude);\(location.coordinate.longitude);\(location.horizontalAccuracy);\(location.altitude);\(location.verticalAccuracy);\(location.timestamp.timeIntervalSince1970)"
//            request.setValue(geoPosition, forHTTPHeaderField: "Geo-Position")
//        }
        
//        headers.forEach { key, value in
//            request.setValue(value, forHTTPHeaderField: key)
//        }
        
        request.timeoutInterval = 10

        if let httpBody = httpBody {
            let jsonData = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            request.httpBody = jsonData
        }

        return request
    }
}
