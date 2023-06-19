//
//  PreviewViewController.swift
//  JobHunt
//
//  Created by Ahmad Shaheer on 13/04/2023.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var resumeImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = MFileManager.shared.readImage(type: .resume)
        
        if let image {
            resumeImgView.image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .right)
        }
        
    }
    

}
