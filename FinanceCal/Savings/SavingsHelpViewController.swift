//
//  SavingsHelpViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import UIKit

class SavingsHelpViewController: UIViewController {

    @IBOutlet weak var Description: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Description.text = "This view contains the parameters for a savings calculation of monthly granularity. \n\nSimply leave one field empty and tap Calculate to calculate the missing field.\n\nThe Month Start/End toggle switch will indicate if your regular deposits are added at the end of the month or the start. For example if you decide to add deposits at the end of the month, the first month's interest will only be calculated upon the initial amount.\n\nIf you don't wish to make additional deposists, simply enter 0 for this field. \n\nTap the table icon at the bottom right to see an amortization of upto the first 100 months (this will only work if you have successfully completed a calculation). \n\nClick history to see and delete your historical calculations. You can tap on a historical calculation to see amortization data as well."
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
