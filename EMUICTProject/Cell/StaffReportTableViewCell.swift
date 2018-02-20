//
//  StaffReportTableViewCell.swift
//  EMUICTProject
//
//  Created by Lynn on 2/19/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class StaffReportTableViewCell: UITableViewCell {

    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var userButton: UIButton!
    
    @IBAction func userPressed(_ sender: Any) {
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
