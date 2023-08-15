//
//  SavingsHelpViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import UIKit

class LoanHelpViewController: UIViewController {

    @IBOutlet weak var Description: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Description.text = "This view contains the parameters for a loan calculation of monthly granularity. \n\nSimply leave one field empty and tap Calculate to calculate the missing field.\n\nPlease note that since this is a loan, your monthly payment amount must at least be slightly higher than the interest. \n\nFor example you take a loan of 100,000 with a monthly interest rate of 10%. If you decide to pay 10,000 monthly, this will result in you paying the loan for an infinite number of months as you are only paying the monthly interest (10% of 100,000 which is 10,000). Consequently a value of 'infinite' will be returned in the Duration in Months field. \n\nClick the table icon at the bottom right to see an amortization of upto the first 100 months (this will only work if you have successfully completed a calculation). \n\nClick history to see and delete your historical calculations. You can tap on a historical calculation to see amortization data as well."
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
