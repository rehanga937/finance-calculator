//
//  HistoryTableViewCell.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var DisplayLabel: UILabel!
    @IBOutlet weak var MainTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
