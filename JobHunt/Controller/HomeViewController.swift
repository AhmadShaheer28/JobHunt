//
//  HomeViewController.swift
//  JobHunt
//
//  Created by User on 01/04/2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getJobs { data, error in
          if let error = error {
            print("Error: \(error.localizedDescription)")
            return
          }
          guard let data = data else {
            print("No data received")
            return
          }
//          do {
//            let decoder = JSONDecoder()
////            let jobs = try decoder.decode([Job].self, from: data)
//            // Handle the retrieved jobs data here
//          } catch {
//            print("Error decoding data: \(error.localizedDescription)")
//          }
            
            print("json => ", String(data: data, encoding: .utf8) ?? "json in nil")
        }
        
    }
    

    func getJobs(completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://jobs.github.com/positions.json"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }.resume()
    }
    
}
