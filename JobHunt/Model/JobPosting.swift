//
//  JobPosting.swift
//  JobHunt
//
//  Created by User on 06/04/2023.
//

import Foundation


struct JobPosting: Codable {
    let jobId : Int
    let employerId : Int?
    let employerName : String?
    let employerProfileId : String?
    let employerProfileName : String?
    let jobTitle : String?
    let locationName : String?
    let minimumSalary : Double?
    let maximumSalary : Double?
    let currency : String?
    let expirationDate : String?
    let date : String?
    let jobDescription : String?
    let applications : Int?
    let jobUrl : String?
    let contractType: String?
    let salary: String?
    let datePosted: String?
}
