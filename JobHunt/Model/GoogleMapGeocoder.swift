//
//  GoogleMapGeocoder.swift
//  JobHunt
//
//  Created by User on 13/04/2023.
//

import Foundation


struct GoogleGeocode : Codable {
    let results: [Result]?
    let status: String?
    
    func getCountry() -> String {
        var city = ""
        guard let first = results?.first?.addressComponents else { return "" }
        
        for add in first {
            for type in add.types ?? [] {
                if type == "country" {
                    city = add.longName ?? ""
                    break
                }
            }
        }
        
        return city
    }
    
    
}

struct Result : Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress: String?
    let geometry: Geometry?
    let placeID: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry = "geometry"
        case placeID = "place_id"
        case types = "types"
    }
}

struct AddressComponent : Codable {
    let longName: String?
    let shortName: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types = "types"
    }
}

struct Geometry : Codable {
    let location: Location?
    let locationType: String?
    let viewport: Bounds?
    let bounds: Bounds?
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case locationType = "location_type"
        case viewport
        case bounds
    }
}

struct Bounds : Codable {
    let northeast: Location?
    let southwest: Location?
}

struct Location : Codable {
    let lat: Double?
    let lng: Double?
}
