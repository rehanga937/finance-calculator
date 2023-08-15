//
//  CommonFunctions.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-22.
//

import Foundation
import UIKit
import OSLog


func checkFieldsReady(_ textFields: UITextField...) -> Bool{
    var count: Int = 0
    for each in textFields{
        if (each.text == ""){count+=1 }
    }//counts number of blank fields
    if (count==1) {
        print("Fields are ready. Can proceed with calculation")
        return true
    }
    if (count>1) {
        for each in textFields{
            if (each.text == ""){
                each.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            }
        }
        print("Too many missing fields")
        return false
    }
    //if count is 0, i.e all fields are filled:
    for each in textFields{
        each.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
    }
    print("All the fields are filled")
    return false
}//function to check if only one of the text fields passed into this function is blank (thus can proceed with the calculation). Otherwise highlights relevant fields.

func resetTextFieldBackgroundColor(_ textFields: UITextField...){
    for each in textFields{
        each.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
}//used to de-highlight text fields that may have been highlighted from checkFieldsReady function

func solveForThisField(_ textFields: UITextField...) -> UITextField?{
    for each in textFields{
        if (each.text == ""){
            return each
        }
    }
    return nil
}//returns which text field the calculation should solve for

func logC(_ base:Double, _ value:Double) -> Double{
    return log(value)/log(base)
}//custom logarithm function using in-built Swift natural logarithm function

func savingsSolveForEndValue (InitialValue x: Double, InterestRatePA m_old: Double, numberOfMonths n: Double, additionalDeposists a: Double, _ monthEnd: Bool) -> Double{
    let y: Double
    let m = 1 + m_old/100
    
    //special case of interest 0%
    if (m == 1){
        if monthEnd{
            y = x + a*(n-1)
        }else{
            y = x + a*n
        }
        return ((y*100).rounded())/100
    }
    
    //regular case
    if monthEnd {
        y = x*pow(m,n) + a*m*((pow(m,(n-1))-1)/(m-1))
    }else{
        y = x*pow(m,n) + a*m*((pow(m,n)-1)/(m-1))
    }
    return ((y*100).rounded())/100
}

func savingsSolveForAdditionalMonthlyDeposits (InitialValue x: Double, InterestRatePA m_old: Double, numberOfMonths n: Double, EndValue y: Double, _ monthEnd: Bool) -> Double{
    let a: Double
    let m = 1 + m_old/100
    
    //special case if interest rate is 0
    if (m == 1){
        if monthEnd{
            a = (y - x)/(n-1)
        }else{
            a = (y - x)/n
        }
        return ((a*100).rounded())/100
    }
    
    //regular case
    if monthEnd {
        a = ((y - x*pow(m,n))/m)*((m-1)/(pow(m,(n-1))-1))
    }else{
        a = ((y - x*pow(m,n))/m)*((m-1)/(pow(m,n)-1))
    }
    return ((a*100).rounded())/100
}

func savingsSolveForInitialValue (AdditionalDeposits a: Double, InterestRatePA m_old: Double, numberOfMonths n: Double, EndValue y: Double, _ monthEnd: Bool) -> Double{
    let x: Double
    let m = 1 + m_old/100
    
    //solving special case of 0% interest
    if (m == 1){
        if monthEnd {
            x = y - a*(n-1)
        }else{
            x = y - a*n
        }
        return ((x*100).rounded())/100
    }
    
    //regular case
    if monthEnd {
        x = (y - a*m*((pow(m,(n-1))-1)/(m-1)))/pow(m,n)
    }else{
        x = (y - a*m*((pow(m,n)-1)/(m-1)))/pow(m,n)
    }
    return ((x*100).rounded())/100
}

func savingsSolveForNumOfMonths (AdditionalDeposits a: Double, InterestRatePA m_old: Double, InitialValue x:Double, EndValue y: Double, _ monthEnd: Bool) -> Double{
    let n: Double
    let m = 1 + m_old/100
    if monthEnd {
        n = logC(m,((m*(y+a)-y)/(x*(m-1)+a)))
    }else{
        n = logC(m,((y-m*(y+a))/(x-m*(x+a))))
    }
    return ((n*100).rounded())/100 //it was considered to round this up to a whole number always, but since there is some benefit to the user to know that the savings will reach its target in just 4.1 months as opposed to 4.9 months, the standard 2 decimal place rounding was kept.
}

func savingsSolveForInterestRatePA (AdditionalDeposits a: Double, numberOfMonths n: Double, InitialValue x:Double, EndValue y: Double, _ monthEnd: Bool) -> Double{
    
    
    
    //POSSIBILITY 1: if a is zero, the equataion can be easily re-arranged to make the interest rate the subject. 
    var m: Double
    if (a == 0){
        m = pow((y/x),(1/n))
        m = (m - 1)*100//converting interest rate into form that makes sense on the app's text field (eg: 2% interest rate i.e. 1.02 becomes 2)
        return ((m*100).rounded())/100
    }
    
    //otherwise, the equation cannot be re-arranged numerically. Therefore we will use the Decimal search method for numerically solving equations, involving a low estimate and a high estimate, and observing sign change of the result to narrow down the estimates. If a sign change is not reported, we will return -1,000,001 indicating that the input values are unreasonable and beyond our initial estimates and can later be transformed into a pop-up or some other form of warning.
    
    //low estimate cannot be 1, as this also results in a divide by zero error.
    //POSSIBILITY 2: m happens to be 1 (i.e. interest rate is 0). And additional amounts deposited at month START. So just check and see before moving on to remaining possibilities.
    if ((x + a*n) == y){return 0}
    
    //POSSIBILITY 3: m happens to be 1 (i.e. interest rate is 0). And additional amounts deposited at month END. So just check and see before moving on to remaining possibilities.
    if ((x + a*(n-1)) == y){return 0}
    
    //POSSIBILITY 4&5&6&7: interest rate is above or below 1. Now we start to use Decimal Search
    func solve_start(_ m: Double) -> Double{
        return x*pow(m,n) - y + a*m*((pow(m,n)-1)/(m-1))
    }
    func solve_end(_ m: Double) -> Double{
        return x*pow(m,n) - y + a*m*((pow(m,(n-1))-1)/(m-1))
    }
    func decimalSearch_start(_ lowhigh: (Double,Double)) -> (Double,Double){
        
        print("Began decimal search")
        
        var low = lowhigh.0
        let high = lowhigh.1
        var lowResult: Double = solve_start(low)
        let highResult: Double = solve_start(high)
        var lowResultIsPositive: Bool
        if (lowResult<0){lowResultIsPositive=false}else{lowResultIsPositive=true}
        var highResultIsPositive: Bool
        if (highResult<0){highResultIsPositive=false}else{highResultIsPositive=true}
        let interval: Double = abs(high - low)/10
        
        print("Low is \(low), High is \(high), LowResult is \(lowResult), High Result is \(highResult)")
        
        if (lowResultIsPositive == highResultIsPositive){
            print("crazy outcome")
            return (Double(-1000001),Double(-1000001))
        }//i.e. a solution cannot be found in the starting low and high range
        
        while (low < high){
            lowResult = solve_start(low)
            print("low is \(low) and its results is \(lowResult)")
            if (lowResult<0){lowResultIsPositive=false}else{lowResultIsPositive=true}
            if (highResultIsPositive == lowResultIsPositive){
                print("Between \(low-interval) and \(low)")
                return (low-interval,low)
            }else{
                low = low + interval
            }
        }
        return (low-interval,low)//this is reached in case low exceeds high upon addition of interval. No matter since when function is called again, the interval is shortened.
    }
    func decimalSearch_end(_ lowhigh: (Double,Double)) -> (Double,Double){
        
        print("Began decimal search")
        
        var low = lowhigh.0
        let high = lowhigh.1
        var lowResult: Double = solve_end(low)
        let highResult: Double = solve_end(high)
        var lowResultIsPositive: Bool
        if (lowResult<0){lowResultIsPositive=false}else{lowResultIsPositive=true}
        var highResultIsPositive: Bool
        if (highResult<0){highResultIsPositive=false}else{highResultIsPositive=true}
        let interval: Double = abs(high - low)/10
        
        print("Low is \(low), High is \(high), LowResult is \(lowResult), High Result is \(highResult)")
        
        if (lowResultIsPositive == highResultIsPositive){
            print("crazy outcome")
            return (Double(-1000001),Double(-1000001))
        }//i.e. a solution cannot be found in the starting low and high range
        
        while (low < high){
            lowResult = solve_end(low)
            print("low is \(low) and its results is \(lowResult)")
            if (lowResult<0){lowResultIsPositive=false}else{lowResultIsPositive=true}
            if (highResultIsPositive == lowResultIsPositive){
                print("Between \(low-interval) and \(low)")
                return (low-interval,low)
            }else{
                low = low + interval
            }
        }
        return (low-interval,low)//this is reached in case low exceeds high upon addition of interval. No matter since when function is called again, the interval is shortened.
    }
    
    //POSSIBILITY 4: Interest rate is above 1. Additional deposits at month start.
    if (monthEnd == false){
        let low: Double = 1.0000001
        let high: Double = 5000
        var lowhigh: (Double,Double) = (low,high)
        
        if (decimalSearch_start(lowhigh) != (Double(-1000001),Double(-1000001))) {
            //var count = 0 //for testing
            //Limits chosen as +or- 0.00001 because user is allowed to enter interest rate of 0.01% granularity (i.e 0.0001)
            while ((solve_start(lowhigh.0) < -0.00001) || (solve_start(lowhigh.0) > 0.00001)){
                //for testing
                /*
                count += 1
                print("count \(count)")
                print()
                 */
                lowhigh = decimalSearch_start(lowhigh)
            }
            lowhigh.0 = (lowhigh.0 - 1)*100
            return ((lowhigh.0*100).rounded())/100
        }
    }
    
    
    //POSSIBILITY 5: Interest rate is above 1. Additional deposits at month end.
    if (monthEnd == true){
        let low : Double = 1.0000001
        let high : Double = 5000
        var lowhigh = (low,high)
        
        if (decimalSearch_end(lowhigh) != (Double(-1000001),Double(-1000001))) {
            while ((solve_end(lowhigh.0) < -0.00001) || (solve_end(lowhigh.0) > 0.00001)){
                lowhigh = decimalSearch_end(lowhigh)
            }
            lowhigh.0 = (lowhigh.0 - 1)*100
            return ((lowhigh.0*100).rounded())/100
        }
    }
    
    
    
    //POSSIBILITY 6: Interest rate is below 1. Additional deposits at month end.
    if (monthEnd == true){
        let low: Double =  0.0000001
        let high: Double = 0.9999999
        var lowhigh = (low,high)
        
        if (decimalSearch_end(lowhigh) != (Double(-1000001),Double(-1000001))) {
            while ((solve_end(lowhigh.0) < -0.00001) || (solve_end(lowhigh.0) > 0.00001)){
                lowhigh = decimalSearch_end(lowhigh)
            }
            lowhigh.0 = (lowhigh.0 - 1)*100
            return ((lowhigh.0*100).rounded())/100
        }
    }
    
    
    //POSSIBILITY 7: Interest rate is below 1. Additional deposits at month start.
    let low: Double = 0.0000001
    let high: Double = 0.9999999
    var lowhigh = (low,high)
    
    if (decimalSearch_start(lowhigh) != (Double(-1000001),Double(-1000001))) {
        while ((solve_start(lowhigh.0) < -0.00001) || (solve_start(lowhigh.0) > 0.00001)){
            lowhigh = decimalSearch_start(lowhigh)
        }
        lowhigh.0 = (lowhigh.0 - 1)*100
        return ((lowhigh.0*100).rounded())/100
    }
    
    //POSSIBILITY 8: Interest rate exists somewhere, but outside my reasonable estimates (i.e. 0.0000001 and +5000) (i.e. 499900% and ~ -4999..00%
    return -1000001 //handle via error pop-up or similar
}



