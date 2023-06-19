//
//  HomeViewController.swift
//  JobHunt
//
//  Created by User on 01/04/2023.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, PickedLocationDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var jobSearchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noJobsLbl: UILabel!
    
    
    var jobPostings = [JobPosting]()
    private var locationManager = CLLocationManager()
    var locationName = ""
    var keyword = "software developer"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupLocation()
                
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        if let searchedText = jobSearchTF.text {
            if !searchedText.isEmpty {
                keyword = searchedText
                let param = ["keywords": "\(searchedText)", "locationName": "\(locationName)"]
                getJobs(param: param)
            }
        }
    }
    
    @IBAction func mapBtnAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "mapVC") as? MapViewController else { return }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getJobs(param: [String: String]) {
        
        noJobsLbl.isHidden = true
        self.loader.isHidden = false
        loader.startAnimating()
        
        NetworkManager.shared.getJobs(baseUrl: Constant.baseURL + EndPoint.search, params: param) { (results: MainApi<[JobPosting]>?, error) in
            
            self.loader.stopAnimating()
            self.loader.isHidden = true
            
            if let results {
                self.noJobsLbl.isHidden = !results.results.isEmpty
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
    
    func setupLocation() {
        locationManager.delegate = self
        
        switch(locationManager.authorizationStatus) {
            
        case .restricted, .denied:
            UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }
    
    func getLocationDetails(latlng: String) {
        
        NetworkManager.shared.fetchJson(withUrl: Constant.mapBaseUrl, latlng: latlng, completion: { (geocode: GoogleGeocode) in
            DispatchQueue.main.async {
                self.locationName = geocode.getCountry()
                let param = ["keywords": "\(self.keyword)", "locationName": "\(self.locationName)"]
                self.getJobs(param: param)
            }
        })
    }
    
    // called when user selects location from map view
    func didSelectLocation(latlng: String) {
        getLocationDetails(latlng: latlng)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let first = locations.first {
            let lat = first.coordinate.latitude
            let lng = first.coordinate.longitude
            getLocationDetails(latlng: "\(lat),\(lng)")
        }
        
        locationManager.stopUpdatingLocation()
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
