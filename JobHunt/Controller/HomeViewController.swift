//
//  HomeViewController.swift
//  JobHunt
//
//  Created by User on 01/04/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var jobSearchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var jobPostings = [JobPosting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        tableView.delegate = self
        tableView.dataSource = self
        
        getJobs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getJobs() {
        let param = ["keywords": "software developer", "locationName": "london"]
        NetworkManager.shared.getJobs(baseUrl: Constant.baseURL + EndPoint.search, params: param) { (results: MainApi<[JobPosting]>?, error) in
            if let results {
                self.jobPostings = results.results
                self.tableView.reloadData()
            }
        }
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobPostings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostingCell", for: indexPath) as? JobPostingCell else { return UITableViewCell() }
        
        cell.jobTitleLbl.text = jobPostings[indexPath.row].jobTitle
        cell.empNameLbl.text = jobPostings[indexPath.row].employerName
        cell.locationLbl.text = jobPostings[indexPath.row].locationName
        cell.empViewLbl.text = jobPostings[indexPath.row].employerName?.prefix(1).uppercased()
        cell.postingView.backgroundColor = generateRandomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "jobDetail") as? JobDetailViewController else { return }
        vc.jobId = jobPostings[indexPath.row].jobId
        navigationController?.pushViewController(vc, animated: true)
    }
}
