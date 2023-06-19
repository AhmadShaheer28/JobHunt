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
    @IBOutlet weak var resumeCardView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileInfoLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var user: UserProfile?
    var hasSelectedCamera = false
    var resumeImg: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resumeCardView.isHidden = true
        profileImgView.layer.cornerRadius = 60
        addProfileBtn.layer.cornerRadius = 16
        resumeCardView.layer.cornerRadius = 12
        dropShadowToCard()
        
        if let uProfile = DBManager.shared.getProfile() {
            user = uProfile
        }
        
        if let user {
            populateUI(with: user)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resumeCardTapped))
        resumeCardView.addGestureRecognizer(tap)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapView)
    }
    
    @objc func resumeCardTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "resumePreview") as? PreviewViewController else { return }
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func populateUI(with user: UserProfile) {
        nameTF.text = user.name
        emailTF.text = user.email
        
        profileImgView.image = MFileManager.shared.readImage(type: .profile) ?? UIImage(named: "ic_avatar")
        showResumeCard()
    }
    
    func showResumeCard() {
        if let url = MFileManager.shared.read(type: .resume).url {
            resumeCardView.isHidden = false
            fileNameLbl.text = url.fileName()
            fileInfoLbl.text = "\(getStringDate(from: url.fileDate()))"
        } else {
            resumeCardView.isHidden = true
        }
    }
    
    func open(_ type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = type
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func dropShadowToCard() {
        DispatchQueue.main.async {
            self.resumeCardView.layer.masksToBounds = false
            self.resumeCardView.layer.shadowColor = UIColor.black.cgColor
            self.resumeCardView.layer.shadowOpacity = 0.2
            self.resumeCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.resumeCardView.layer.shadowRadius = 4
            self.resumeCardView.layer.shadowPath = UIBezierPath(rect: self.resumeCardView.bounds).cgPath
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getStringDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let sDate = dateFormatter.string(from: date)
        return sDate
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
        let profileimg = profileImgView.image?.pngData()
        
        let user = UserProfile(name: name, email: email)
        
        if let profileimg {
            _ = MFileManager.shared.savePNG(data: profileimg, type: .profile)
        }
        
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
                if let resume = image.pngData() {
                    _ = MFileManager.shared.savePNG(data: resume, type: .resume)
                    self.showResumeCard()
                }
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


//MARK: - URL extension

extension URL {
    func fileDate() -> Date {
        var fileDate = Date()
        do {
            let resources = try self.resourceValues(forKeys:[.creationDateKey])
            fileDate = resources.creationDate!
            print ("\(fileDate)")
        } catch {
            print("Error: \(error)")
        }
        
        return fileDate
    }
    
    func fileName() -> String {
        return self.deletingPathExtension().lastPathComponent
    }
}
