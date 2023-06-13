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
    
    func removeSavedJob(jobId: Int) {
        guard let context else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedJob")
        fetchRequest.predicate = NSPredicate(format: "jobId == %@", "\(jobId)")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [SavedJob] {
                
                if let res = results.first {
                    context.delete(res)
                }
                
            } else {
                // Error deleting data
            }
        } catch let error {
            print("Save error", error.localizedDescription)
        }
        
        delegate?.saveContext()
    }
    
    func isSavedJob(jobId: Int) -> Bool {
        guard let context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedJob")
        fetchRequest.predicate = NSPredicate(format: "jobId == %@", "\(jobId)")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [SavedJob] {
                if results.count > 0 {
                    print(results.first?.jobTitle ?? "")
                    return true
                }
            }
        } catch let error {
            print("Save error", error.localizedDescription)
        }
        
        return false
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
            print("error", error.localizedDescription)
        }
        
        return []
    }
    
    //MARK: - Profile methods
    
    func saveProfile(user: UserProfile) {
        guard let context else { return }
        guard let userPro = NSEntityDescription.entity(forEntityName: "UProfile", in: context) else { return }
        
        let saved = NSManagedObject(entity: userPro, insertInto: context)
        
        saved.setValue(user.name, forKey: "name")
        saved.setValue(user.email, forKey: "email")
        saved.setValue(user.profileImg, forKey: "profileImg")
        saved.setValue(user.resume, forKey: "resume")
        
        do { try context.save() }
        catch let error { print("error while saving Data", error.localizedDescription) }
    }
    
    func getProfile() -> UserProfile? {
        guard let context else { return nil }
        var user: UserProfile?

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UProfile")

        do {
            guard let data = try context.fetch(fetchRequest) as? [UProfile] else { return nil }

            let profile = data.first
            
            if let profile {
                if let name = profile.name, let email = profile.email {
                    let pimage = profile.profileImg ?? Data()
                    let resume = profile.resume ?? Data()
                    user = UserProfile(name: name, email: email, profileImg: pimage, resume: resume)
                }
            }

            return user

        } catch let error {
            print("error", error.localizedDescription)
        }

        return nil
    }
    
}
