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
    
}
