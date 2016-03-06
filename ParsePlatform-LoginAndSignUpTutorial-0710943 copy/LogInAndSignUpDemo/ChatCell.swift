//
//  ChatCell.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/27/16.
//
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture:UIImageView?
    @IBOutlet weak var nameLabel:UILabel?
    @IBOutlet weak var messsageLabel:UITextView?
    @IBOutlet weak var messsageLabelBackground:UIImageView?
    @IBOutlet weak var timeStamp:UILabel?
    @IBOutlet weak var messageLabelHeightConstraint:NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
