//
//  JobPostingCell.swift
//  JobHunt
//
//  Created by Ahmad Shaheer on 06/04/2023.
//

import UIKit

class JobPostingCell: UITableViewCell {
    
    @IBOutlet weak var postingView: UIView!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var empViewLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        postingView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
