//
//  NetworkManager.swift
//  JobHunt
//
//  Created by User on 06/04/2023.
//

import Foundation


struct Constant {
    static let baseURL = "https://www.reed.co.uk/api/1.0/"
    static let mapBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    static let apiKey = "REED_API_KEY"
    static let googleMapAPIKey = "MAP_API_KEY"
}

struct EndPoint {
    static let job = "jobs"
    static let search = "search"
}


class NetworkManager {
    static let shared = NetworkManager()
    
    func getJobs<T: Decodable>(baseUrl: String = Constant.baseURL, params: [String: String] = [:], completion: @escaping (T?, String?) -> Void) {
        
        guard let url = generateUrl(baseUrl: baseUrl, params: params) else { return }

        var request = URLRequest(url: url)

        let username = "\(Constant.apiKey)"
        let password = ""
        let loginData = "\(username):\(password)".data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("json is downloaded")
                
                if let error = error {
                    completion(nil, error.localizedDescription) ; return
                }
                
                guard let data = data else { completion(nil, "Unable to get the data") ; return }
                print("json ===========>\n", String(data: data, encoding: .utf8) ?? "no json")
                print(url)
                do {
                    completion(try JSONDecoder().decode(T.self, from: data), nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
            }
        }.resume()

    }
    
    func fetchJson<T: Decodable>(withUrl url: String, latlng: String, completion: @escaping (T) -> Void, error: ((String) -> Void)? = nil ) {
        
        
        let prams = ["key": Constant.googleMapAPIKey, "latlng": latlng]
        
        guard let _url = generateUrl(baseUrl: url, params: prams) else { return }
        
        var request = URLRequest(url: _url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                if let error = error { error(err.localizedDescription) }
                print("error \(err.localizedDescription)")
                return
            }
            
            guard let data = data else { print("error while getting the data") ; return }
            print("json is downloaded")
            do {
                
                let decoder = JSONDecoder()
                print("json => ", String(data: data, encoding: .utf8) ?? "json in nil")
                completion(try decoder.decode(T.self, from: data))
                
            } catch let err {
                print("error in json decoder \(err.localizedDescription)")
                print("url is \(url)")
                print("json => ", String(data: data, encoding: .utf8) ?? "json in nil")
                if let error = error { error(err.localizedDescription) }
            }
            
        }.resume()
        
    }
    
    
    private func generateUrl(baseUrl: String, params: [String: String] = [:]) -> URL? {
        
        guard !params.isEmpty else { return URL(string: baseUrl) }
        
        var componenet = URLComponents(string: baseUrl)
        componenet?.queryItems = params.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        return componenet?.url
        
    }
}
