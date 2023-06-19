//
//  MapViewController.swift
//  JobHunt
//
//  Created by User on 14/04/2023.
//

import UIKit
import GoogleMaps


protocol PickedLocationDelegate: NSObject {
    func didSelectLocation(latlng: String)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var locationServicesView: UIView!
    @IBOutlet weak var locationServicesLabel: UILabel!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var locationPinCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationPinView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var selectLocBtn: UIButton!
    
    private var locationManager = CLLocationManager()
    private var selectedLocation = ""
    weak var delegate: PickedLocationDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        selectLocBtn.isEnabled = false
        selectLocBtn.backgroundColor = .black.withAlphaComponent(0.6)
        
        mapView.delegate = self
        setLocationServiceLabel()
        setupLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewAppearFromForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func locationServiceBtnTapped(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func selectLocationAction(_ sender: Any) {
        delegate?.didSelectLocation(latlng: selectedLocation)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func viewAppearFromForeground() {
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        
        switch(locationManager.authorizationStatus) {
            
        case .restricted, .denied:
            locationServicesView.isHidden = false
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationServicesView.isHidden = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        case .notDetermined:
            locationServicesView.isHidden = true
            locationManager.requestWhenInUseAuthorization()
            
        default:
            locationServicesView.isHidden = true
            break
        }
    }
    
    func setLocationServiceLabel() {
        
        let text = "JobHunt requires access to your location"
        let subtitle = "Enable location services for a more accurate experience"
        
        let fulltext = text+"\n"+subtitle
        
        let attributedString = NSMutableAttributedString(string: fulltext)
        
        attributedString.addAttributes([
            .font: UIFont(name: "Avenir-Book", size: 17)!,
            .foregroundColor: UIColor.black
            ], range: (fulltext as NSString).range(of: text))
        
        attributedString.addAttributes([
            .font: UIFont(name: "Avenir-Book", size: 17)!,
            .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            ], range: (fulltext as NSString).range(of: subtitle))
        
        locationServicesLabel.attributedText = attributedString
        
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let first = locations.first else { return }
        mapView.animate(toLocation: first.coordinate)
        mapView.animate(toZoom: 12)
        
        locationManager.stopUpdatingLocation()
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.locationPinCenterYConstraint.constant = -45
            self.view.layoutIfNeeded()
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        UIView.animate(withDuration: 0.2) {
            self.locationPinCenterYConstraint.constant = -35
            self.view.layoutIfNeeded()
        }
        
        selectLocBtn.isEnabled = true
        selectLocBtn.backgroundColor = .black
        selectedLocation = "\(position.target.latitude),\(position.target.longitude)"
    }
}
