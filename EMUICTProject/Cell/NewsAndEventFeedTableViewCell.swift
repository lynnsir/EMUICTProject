//
//  NewsAndEventFeedTableViewCell.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 3/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class NewsAndEventFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

}
