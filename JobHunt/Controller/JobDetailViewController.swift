//
//  JobDetailViewController.swift
//  JobHunt
//
//  Created by User on 06/04/2023.
//

import UIKit

class JobDetailViewController: UIViewController {

    @IBOutlet weak var empNameLetterLbl: UILabel!
    @IBOutlet weak var postDurationTillNowLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var jobLocationLbl: UILabel!
    @IBOutlet weak var jobDescriptionLbl: UILabel!
    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var salaryRangeLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var jobLinkLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var jobId = 0
    var jobDetail: JobPosting?
    var isJobSaved = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        jobLinkLbl.addGestureRecognizer(tap)
        
        isJobSaved = DBManager.shared.isSavedJob(jobId: jobId)

        isJobSaved ? saveBtn.setImage(UIImage(named: "ic_remove"), for: .normal) : saveBtn.setImage(UIImage(named: "ic_save"), for: .normal)
        
        getJobDetail()
    }
    
    @objc func linkTapped() {
        if let url = URL(string: jobLinkLbl.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if !isJobSaved {
            if let jd = jobDetail {
                DBManager.shared.saveJob(job: jd)
                isJobSaved = false
                showAlert(title: "Success", message: "Job saved successfully!")
                saveBtn.setImage(UIImage(named: "ic_remove"), for: .normal)
            }
        } else {
            DBManager.shared.removeSavedJob(jobId: jobId)
            isJobSaved = true
            showAlert(title: "Success", message: "Job removed successfully!")
            saveBtn.setImage(UIImage(named: "ic_save"), for: .normal)
        }
    }
    
    
    func getJobDetail() {
        NetworkManager.shared.getJobs(baseUrl: Constant.baseURL + EndPoint.job + "/\(jobId)") { (results: JobPosting?, error) in
            if let results {
                self.populateUI(jobDet: results)
            } else {
                print("Error: \(error ?? "")")
            }
        }
    }
    
    func populateUI(jobDet: JobPosting) {
        jobDetail = jobDet
        empNameLetterLbl.text = jobDet.employerName?.prefix(1).uppercased()
        jobTypeLbl.text = jobDet.contractType
        jobTitleLbl.text = jobDet.jobTitle
        expireDateLbl.text = jobDet.expirationDate
        empNameLbl.text = jobDet.employerName
        jobDescriptionLbl.text = jobDet.jobDescription?.htmlToString
        jobLocationLbl.text = jobDet.locationName
        salaryRangeLbl.text = jobDet.salary ?? "N/A"
        
        let postDate = jobDet.datePosted
        let start = toDate(postDate ?? "") ?? Date()
        
        let days = daysBetween(start: start, end: Date())
        
        postDurationTillNowLbl.text = "\(days) days ago"
        jobLinkLbl.text = jobDet.jobUrl
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day! + 1
    }
    
    
    func toDate(_ date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: date)
        
        return date
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
