//
//  DBManager.swift
//  JobHunt
//
//  Created by User on 09/04/2023.
//

import Foundation
import CoreData
import UIKit

class DBManager: NSObject {
    
    private let delegate = UIApplication.shared.delegate as? AppDelegate
    private let context: NSManagedObjectContext?
    
    static let shared = DBManager()
    
    
    private override init() {
        context = delegate?.persistentContainer.viewContext
    }
    
    func saveJob(job: JobPosting) {
        guard let context else { return }
        guard let savedJob = NSEntityDescription.entity(forEntityName: "SavedJob", in: context) else { return }
        
        let saved = NSManagedObject(entity: savedJob, insertInto: context)
        
        saved.setValue(job.jobId, forKey: "jobId")
        saved.setValue(job.jobTitle, forKey: "jobTitle")
        saved.setValue(job.employerName, forKey: "employerName")
        saved.setValue(job.locationName, forKey: "locationName")
        
        do { try context.save() }
        catch let error { print("error while saving Data", error.localizedDescription) }
    }
    
    
    
    func getAllSavedJobs() -> [JobPosting] {
        guard let context else { return [] }
        var savedJobs = [JobPosting]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedJob")
        
        do {
            guard let data = try context.fetch(fetchRequest) as? [SavedJob] else { return [] }
            
            for job in data {
                let id = job.jobId
                if let title = job.jobTitle, let empName = job.employerName, let location = job.locationName {
                    savedJobs.append(JobPosting(jobId: Int(id), employerId: 0, employerName: empName, employerProfileId: "", employerProfileName: "", jobTitle: title, locationName: location, minimumSalary: 0, maximumSalary: 0, currency: "", expirationDate: "", date: "", jobDescription: "", applications: 0, jobUrl: "", contractType: "", salary: "", datePosted: ""))
                }
            }
            
            return savedJobs
            
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return []
    }
    
}
