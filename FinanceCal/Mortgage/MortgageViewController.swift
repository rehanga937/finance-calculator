//
//  ViewController.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-22.
//

import UIKit
import OSLog

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    var amortizationReady = false
    var mortgageRecords = [mortgageRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mortgages"
        
        InitialValue.delegate = self
        InterestRatePA.delegate = self
        DurationInMonths.delegate = self
        Notes.delegate = self
        PaymentValue.delegate = self
        

        //loading history array
        if let history = load()  {
            if (history.count == 0) {
                print("history empty")
            }
            else {
                mortgageRecords  = history
            }
        }
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch (identifier){
        case "MortgageAmortization":
            if amortizationReady { return true}
            else{return false}
        default: return true
        }
        
    }//disables segue to amortization view if there is no complete calculation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "MortgageAmortization":
            print("Mortgage Amortization selected")
            let destVC = segue.destination as! MortgageAmortization_TableViewController
            destVC.x = Double(InitialValue.text!) ?? 0
            destVC.a = Double(PaymentValue.text!) ?? 0
            destVC.notes = Notes.text!
            destVC.n = Double(DurationInMonths.text!)?.rounded(.up) ?? 0
            destVC.m = (Double(InterestRatePA.text!) ?? 10)
        case "MortgageHistory":
            let destVC = segue.destination as! MortgageHistoryViewTableViewController
            destVC.array = mortgageRecords
        case "MortgageHelp":
            print("Mortgage Help Clicked")
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//Used to pass data during the Amortization view segue
    
    
    
    //text fields
    @IBOutlet weak var InitialValue: UITextField!
    @IBOutlet weak var Notes: UITextField!
    @IBOutlet weak var PaymentValue: UITextField!
    @IBOutlet weak var DurationInMonths: UITextField!
    @IBOutlet weak var InterestRatePA: UITextField!
    
    
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
        resetTextFieldBackgroundColor(PaymentValue,InterestRatePA,DurationInMonths,InitialValue)
        amortizationReady = false
    }//resets any highlighted text fields upon end-edit
    
    
    private func save() {
        var isSuccessfulSave : Bool = false
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: mortgageRecords, requiringSecureCoding: false)
            try data.write(to: mortgageRecord.ArchiveURL)
            isSuccessfulSave = true
        } catch {
            print("Couldn't save mortgage records")
        }
        
        if isSuccessfulSave {
            os_log("Mortgage records saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save mortgage records", log: OSLog.default, type: .error)
        }
    } //used to save calculation history
    private func load() -> [mortgageRecord]? {
        
        do {
            
            let rawdata = try Data(contentsOf: mortgageRecord.ArchiveURL)
            
            let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as! [mortgageRecord]
            
            return unarchivedData
        } catch {
            print("loaded mortgage records")
            return nil
        }
    } //used to load calculation history array on viewDidLoad
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as? MortgageHistoryViewTableViewController
        mortgageRecords = sourceVC?.array ?? []
        save()
    } //used to get array from history view in case any records were deleted.
    
    
    @IBAction func Calculate(_ sender: Any) {
        
        print("Calculate button pressed")
        
        var x = Double(InitialValue.text!)
        var m = Double(InterestRatePA.text!)
        var n = Double(DurationInMonths.text!)
        var a = Double(PaymentValue.text!)
        a = (a ?? 0) * 12 //since mortgage is an annual granularity loan but with payments calculated monthly
        
        if(checkFieldsReady(InterestRatePA,PaymentValue,DurationInMonths,InitialValue)){
            resetTextFieldBackgroundColor(InterestRatePA,PaymentValue,DurationInMonths,InitialValue)//reset color of any highlighted fields now that checks are complete
            switch(solveForThisField(InterestRatePA,PaymentValue,DurationInMonths,InitialValue)!){
            case PaymentValue:
                print("Solving for payment value")
                PaymentValue.text = String(((((mortgageSolveForPaymentValue(InitialValue: x!, InterestRatePA: m!, numberOfMonths: n!)))*100).rounded())/100)
                a = Double(PaymentValue.text!)
                a = (a ?? 0) * 12 //since mortgage is an annual granularity loan but with payments calculated monthly
            case InitialValue:
                print("Solving for initial value")
                InitialValue.text = String(loanSolveForInitialValue(PaymentValue: a!, InterestRatePA: m!, numberOfMonths: n!))
                x = Double(InitialValue.text!)
            case DurationInMonths:
                print("Solving for number of months")
                DurationInMonths.text = String(loanSolveForNumOfMonths(PaymentValue: a!, InterestRatePA: m!, InitialValue: x!))
                n = Double(DurationInMonths.text!)
            case InterestRatePA:
                print("Solving for interest rate p.a.")
                InterestRatePA.text = String(loanSolveForInterestRatePA(PaymentValue: a!, numberOfMonths: n!, InitialValue: x!))
                m = Double(InterestRatePA.text!)
            default:
                print("default case invoked for some reason")
            }
            amortizationReady = true
            mortgageRecords.append(mortgageRecord(x: x!, m: m!, n: n!, a: a!,  notes: Notes.text!)!)
            if (mortgageRecords.count) > 100 {
                mortgageRecords.remove(at: 0)
            }//history max size is 100 records
            print("length of mortgage records array is \(mortgageRecords.count)")
            save()
        }
    }//upon clicking calculate button
}

