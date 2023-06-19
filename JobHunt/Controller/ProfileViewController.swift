//
//  ProfileViewController.swift
//  JobHunt
//
//  Created by User on 03/04/2023.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var resumeImgView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var user: UserProfile?
    var hasSelectedCamera = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        profileImgView.image = UIImage(data: user.profileImg!)
        resumeImgView.image = UIImage(data: user.resume!)
    }
    
    func open(_ type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = type
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addProfileBtnAction(_ sender: Any) {
        hasSelectedCamera = false
        self.open(.photoLibrary)
    }
    
    @IBAction func uploadResumeAction(_ sender: Any) {
        hasSelectedCamera = true
        open(.camera)
    }
    
    @IBAction func saveProfileAction(_ sender: Any) {
        let name = nameTF.text ?? ""
        let email = emailTF.text ?? ""
        let profileimg = profileImgView.image?.jpegData(compressionQuality: 1)
        let resume = resumeImgView.image?.jpegData(compressionQuality: 1)
        
        let user = UserProfile(name: name, email: email, profileImg: profileimg, resume: resume)
        
        DBManager.shared.saveProfile(user: user)
        showAlert(title: "Profile saved!", message: "")
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            if !hasSelectedCamera {
                profileImgView.image = image
            } else {
                resumeImgView.image = image
            }
            
        }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
