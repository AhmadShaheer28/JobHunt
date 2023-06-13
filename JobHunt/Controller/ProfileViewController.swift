//
//  ProfileViewController.swift
//  JobHunt
//
//  Created by User on 03/04/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var resumeImgView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var user: UserProfile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileImgView.layer.cornerRadius = 60
        addProfileBtn.layer.cornerRadius = 16
        
        if let uProfile = DBManager.shared.getProfile() {
            user = uProfile
        }
        
        if let user {
            populateUI(with: user)
        }
        
    }
    
    func populateUI(with user: UserProfile) {
        nameTF.text = user.name
        emailTF.text = user.email
        
        profileImgView.image = UIImage(data: user.profileImg)
        resumeImgView.image = UIImage(data: user.resume)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addProfileBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func uploadResumeAction(_ sender: Any) {
    }
    
    @IBAction func saveProfileAction(_ sender: Any) {
        let name = nameTF.text ?? ""
        let email = emailTF.text ?? ""
        let profileimg = profileImgView.image?.pngData() ?? Data()
        let resume = resumeImgView.image?.pngData() ?? Data()
        
        let user = UserProfile(name: name, email: email, profileImg: profileimg, resume: resume)
        
        DBManager.shared.saveProfile(user: user)
        showAlert(title: "Profile saved!", message: "")
    }
}
