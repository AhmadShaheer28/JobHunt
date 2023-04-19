//
//  APIModel.swift
//  JobHunt
//
//  Created by User on 06/04/2023.
//

import Foundation


struct MainApi<T: Codable>: Codable {
    let totalResults: Int
    let results: T!
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
        results = try values.decode(T.self, forKey: .results)
    }
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "totalResults"
        case results = "results"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.totalResults, forKey: .totalResults)
        try container.encode(self.results, forKey: .results)
    }
}
