//
//  ChatTabViewCell.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/27/16.
//
//

import UIKit

class InboxViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var messsageLabel:UILabel!
    @IBOutlet weak var timeStamp:UILabel!
    @IBOutlet weak var messageLabelHeightConstraint:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
