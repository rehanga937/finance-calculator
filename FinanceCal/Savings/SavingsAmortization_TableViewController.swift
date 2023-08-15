//
//  SavingsAmortization_TableViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-26.
//

import UIKit

class SavingsAmortization_TableViewController: UITableViewController {

    @IBOutlet weak var Description: UITextView!
    
    var x: Double = 0
    var y: Double = 0
    var a: Double = 0
    var n: Double = 1
    var m: Double = 1.1
    var monthEnd = true
    var notes: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Savings Amortization"
        
        var monthEndforDescription: String
        if monthEnd { monthEndforDescription = "month end"} else { monthEndforDescription = "month start"}
        
        Description.text = "\(notes)\n\nInitial Value: \(x)\nMonthly Interest Rate: \(m)%\nAdditional Monthly Deposits of \(a) made at \(monthEndforDescription)\nDuration in months: \(n)\nEnd Value: \(y)"
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }//1 section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (n<100){return Int(n)}else{return 100}
    } //number of rows is equal to the number of months upto a maximum of 100
     
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmortizationCellReuseIdentifier", for: indexPath) as? AmortizationCell

        cell!.Label1.text = "Month " + String(indexPath.row+1) + " : "
        var yForAGivenMonth: Double
        yForAGivenMonth = savingsSolveForEndValue(InitialValue: x, InterestRatePA: m, numberOfMonths: Double((indexPath.row + 1)), additionalDeposists: a, monthEnd)
        cell!.Label2.text = String(yForAGivenMonth)

        return cell!
    }//calculates the amortization steps for the rows
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITextView? {
        return Description
    }//description text view is the header for the table
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }//header height
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
