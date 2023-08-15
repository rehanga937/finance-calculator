//
//  AmortizationCell.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-26.
//

import UIKit

class AmortizationCell: UITableViewCell {

  
    @IBOutlet weak var Label1: UILabel! //used to display month #: (or year # in case of mortgage)
    @IBOutlet weak var Label2: UILabel! //used to display savings value for that month (or year in case of mortgage)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
