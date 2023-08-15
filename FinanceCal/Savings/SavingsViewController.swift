//
//  ViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-22.
//

import UIKit
import OSLog

class ViewController: UIViewController, UITextFieldDelegate {
    
    var monthEnd = true
    var amortizationReady = false
    var savingsRecords = [savingsRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Savings"
        
        InitialValue.delegate = self
        InterestRatePA.delegate = self
        DurationInMonths.delegate = self
        AdditionalMonthlyDeposits.delegate = self
        EndValue.delegate = self
        Notes.delegate = self
        
        //properties of the Month Start/End toggle switch
        let fontMonthSwitch = UIFont.systemFont(ofSize: 8)
        monthSwitch.setTitleTextAttributes([NSAttributedString.Key.font: fontMonthSwitch], for: .normal)
        monthSwitch.selectedSegmentIndex = 1
        
        //loading history array
        if let history = load()  {
            if (history.count == 0) {
                print("history empty")
            }
            else {
                savingsRecords  = history
            }
        }
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch (identifier){
        case "Amortization":
            if amortizationReady { return true}
            else{return false}
        default: return true
        }
        
    }//disables segue to amortization view if there is no complete calculation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "Amortization":
            let destVC = segue.destination as! SavingsAmortization_TableViewController
            destVC.x = Double(InitialValue.text!) ?? 0
            destVC.notes = Notes.text!
            destVC.a = Double(AdditionalMonthlyDeposits.text!) ?? 0
            destVC.n = Double(DurationInMonths.text!)?.rounded(.up) ?? 0
            destVC.m = (Double(InterestRatePA.text!) ?? 10)
            destVC.monthEnd = monthEnd
            destVC.y = Double(EndValue.text!) ?? 0
        case "History":
            let destVC = segue.destination as! HistoryViewTableViewController
            destVC.array = savingsRecords
        case "SavingsHelp":
            print("Savings Help Clicked")
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//Used to pass data during the Amortization view segue
    
    
    @IBAction func monthSwitchAction(_ sender: Any) {
        amortizationReady = false
        switch monthSwitch.selectedSegmentIndex{
            case 0: monthEnd = false
            case 1: monthEnd = true
            default: break
        }
    }
    @IBOutlet weak var monthSwitch: UISegmentedControl!
    
    //text fields
    @IBOutlet weak var EndValue: UITextField!
    @IBOutlet weak var InterestRatePA: UITextField!
    @IBOutlet weak var AdditionalMonthlyDeposits: UITextField!
    @IBOutlet weak var DurationInMonths: UITextField!
    @IBOutlet weak var InitialValue: UITextField!
    @IBOutlet weak var Notes: UITextField!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField.keyboardType == .decimalPad, let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }//implements decimal place validity (at-most 2 decimal places) for the numerical fields that use the decimal pad keyboard
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resetTextFieldBackgroundColor(EndValue,InterestRatePA,AdditionalMonthlyDeposits,DurationInMonths,InitialValue)
        amortizationReady = false
    }//resets any highlighted text fields upon end-edit
    
    
    private func save() {
        var isSuccessfulSave : Bool = false
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: savingsRecords, requiringSecureCoding: false)
            try data.write(to: savingsRecord.ArchiveURL)
            isSuccessfulSave = true
        } catch {
            print("Couldn't save savings records")
        }
        
        if isSuccessfulSave {
            os_log("Savings records saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save savings records", log: OSLog.default, type: .error)
        }
    } //used to save calculation history
    private func load() -> [savingsRecord]? {
        
        do {
            
            let rawdata = try Data(contentsOf: savingsRecord.ArchiveURL)
            
            let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as! [savingsRecord]
            
            return unarchivedData
        } catch {
            print("loaded savings records")
            return nil
        }
    } //used to load calculation history array on viewDidLoad
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as? HistoryViewTableViewController
        savingsRecords = sourceVC?.array ?? []
        save()
    } //used to get array from history view in case any records were deleted.
    
    
    @IBAction func Calculate(_ sender: Any) {
        
        print("Calculate button pressed")
        
        var x = Double(InitialValue.text!)
        var m = Double(InterestRatePA.text!)
        var n = Double(DurationInMonths.text!)
        var a = Double(AdditionalMonthlyDeposits.text!)
        var y = Double(EndValue.text!)
        
        if(checkFieldsReady(EndValue,InterestRatePA,AdditionalMonthlyDeposits,DurationInMonths,InitialValue)){
            resetTextFieldBackgroundColor(EndValue,InterestRatePA,AdditionalMonthlyDeposits,DurationInMonths,InitialValue)//reset color of any highlighted fields now that checks are complete
            switch(solveForThisField(EndValue,InterestRatePA,AdditionalMonthlyDeposits,DurationInMonths,InitialValue)!){
            case EndValue:
                print("Solving for end value")
                EndValue.text = String(savingsSolveForEndValue(InitialValue: x!, InterestRatePA: m!, numberOfMonths: n!, additionalDeposists: a!, monthEnd))
                y = Double(EndValue.text!)
            case AdditionalMonthlyDeposits:
                print("Solving for additional monthly deposits")
                AdditionalMonthlyDeposits.text = String(savingsSolveForAdditionalMonthlyDeposits(InitialValue: x!, InterestRatePA: m!, numberOfMonths: n!, EndValue: y!, monthEnd))
                a = Double(AdditionalMonthlyDeposits.text!)
            case InitialValue:
                print("Solving for initial value")
                InitialValue.text = String(savingsSolveForInitialValue(AdditionalDeposits: a!, InterestRatePA: m!, numberOfMonths: n!, EndValue: y!, monthEnd))
                x = Double(InitialValue.text!)
            case DurationInMonths:
                print("Solving for number of months")
                DurationInMonths.text = String(savingsSolveForNumOfMonths(AdditionalDeposits: a!, InterestRatePA: m!, InitialValue: x!, EndValue: y!, monthEnd))
                n = Double(DurationInMonths.text!)
            case InterestRatePA:
                print("Solving for monthly interest rate")
                InterestRatePA.text = String(savingsSolveForInterestRatePA(AdditionalDeposits: a!, numberOfMonths: n!, InitialValue: x!, EndValue: y!, monthEnd))
                m = Double(InterestRatePA.text!)
            default:
                print("default case invoked for some reason")
            }
            amortizationReady = true
            savingsRecords.append(savingsRecord(x: x!, m: m!, n: n!, a: a!, monthEnd: monthEnd, y: y!, notes: Notes.text!)!)
            if (savingsRecords.count) > 100 {
                savingsRecords.remove(at: 0)
            }//history max size is 100 records
            print("length of savings records array is \(savingsRecords.count)")
            save()
        }
    }//upon clicking calculate button
}

