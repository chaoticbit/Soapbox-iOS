//
//  StatsTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var upvoteCount: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        roundedView.layer.backgroundColor = UIColor.white.cgColor
        roundedView.layer.cornerRadius = 20.0
        roundedView.layer.borderWidth = 1
        roundedView.layer.borderColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}