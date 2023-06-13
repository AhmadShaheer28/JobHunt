//
//  SavedJobViewController.swift
//  JobHunt
//
//  Created by User on 03/04/2023.
//

import UIKit

class SavedJobViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jobPostings = [JobPosting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobPostings = DBManager.shared.getAllSavedJobs()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

}

extension SavedJobViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobPostings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostingCell", for: indexPath) as? JobPostingCell else { return UITableViewCell() }
        
        cell.jobTitleLbl.text = jobPostings[indexPath.row].jobTitle
        cell.empNameLbl.text = jobPostings[indexPath.row].employerName
        cell.locationLbl.text = jobPostings[indexPath.row].locationName
        cell.empViewLbl.text = jobPostings[indexPath.row].employerName?.prefix(1).uppercased()
//        cell.postingView.backgroundColor = generateRandomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "jobDetail") as? JobDetailViewController else { return }
        vc.jobId = jobPostings[indexPath.row].jobId
        navigationController?.pushViewController(vc, animated: true)
    }
}
