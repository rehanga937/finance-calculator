//
//  HistoryViewTableViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import UIKit
import OSLog

class HistoryViewTableViewController: UITableViewController {
    
    var array = [savingsRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Savings History"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }//1 section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }//number of rows = array.count

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCellReuseIdentifier", for: indexPath) as? HistoryTableViewCell
        
        let endStart: String
        if (array[array.count - 1 - indexPath.row].monthEnd){
            endStart = "month end"
        }else{
            endStart = "month start"
        }
        
        cell!.DisplayLabel.text = "\(array[array.count - 1 - indexPath.row].notes)\nInitial Value: \(array[array.count - 1 - indexPath.row].x)\nMonthly Interest Rate: \(array[array.count - 1 - indexPath.row].m)%\nAdditional Monthly Deposits of \(array[array.count - 1 - indexPath.row].a) made at \(endStart)\nDuration in months: \(array[array.count - 1 - indexPath.row].n)\nEnd Value: \(array[array.count - 1 - indexPath.row].y)"
        

        return cell!
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
        
    }//segue will be performed (only 1 segeue to amortization view)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "HistoryToAmortize":
            
            let destVC = segue.destination as! SavingsAmortization_TableViewController
            
            let selectedCell = sender as? HistoryTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell!)
            let selectedRecord = array[array.count - 1 - indexPath!.row]
            
            destVC.x = selectedRecord.x
            destVC.m = selectedRecord.m
            destVC.a = selectedRecord.a
            destVC.n = selectedRecord.n
            destVC.y = selectedRecord.y
            destVC.notes = selectedRecord.notes
            destVC.monthEnd = selectedRecord.monthEnd
            
        default: print("default case")
        }
    }//Used to pass data during the Amortization view segue

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            array.remove(at: array.count - 1 - indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


    
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
