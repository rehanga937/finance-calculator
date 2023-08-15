//
//  CommonFunctions.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-22.
//

import Foundation
import UIKit
import OSLog

//checkFieldsReady,resetTextFieldBackgroundColor, solveForThisField and logC functions can be borrowed from the Savings Common Functions


func loanSolveForPaymentValue (InitialValue x: Double, InterestRatePA m_old: Double, numberOfMonths n: Double) -> Double{
    let a: Double
    let m = m_old/100
    
    a = x*m + x*m/(-1+pow((1+m),n))
    
    return ((a*100).rounded())/100
}

func loanSolveForInitialValue (PaymentValue a: Double, InterestRatePA m_old: Double, numberOfMonths n: Double) -> Double{
    let x: Double
    let m = m_old/100
    
    x = a*(-1 + pow((1+m),n))/(m*pow((1+m),n))
    
    return ((x*100).rounded())/100
}

func loanSolveForNumOfMonths (PaymentValue a: Double, InterestRatePA m_old: Double, InitialValue x:Double) -> Double{
    let n: Double
    let m = m_old/100
    
    n = logC((1+m), (a/(a-x*m)))
    
    return ((n*100).rounded())/100 //it was considered to round this up to a whole number always, but since there is some benefit to the user to know that the savings will reach its target in just 4.1 months as opposed to 4.9 months, the standard 2 decimal place rounding was kept.
}

func loanSolveForInterestRatePA (PaymentValue a: Double, numberOfMonths n: Double, InitialValue x:Double) -> Double{
    
    
    //We use Decimal Search
    func solve(_ m: Double) -> Double{
        return x - (a - x*m)*((-1 + pow((1+m),n))/m)
    }

    func decimalSearch(_ lowhigh: (Double,Double)) -> (Double,Double){
        
        print("Began decimal search")
        
        var low = lowhigh.0
        let high = lowhigh.1
        var lowResult: Double = solve(low)
        let highResult: Double = solve(high)
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
            lowResult = solve(low)
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

    
    //Solving. Interest rate must be positive i.e. multiplier must be > 1.
    let low: Double = 0.0000001
    let high: Double = 5000
    var lowhigh: (Double,Double) = (low,high)
    
    if (decimalSearch(lowhigh) != (Double(-1000001),Double(-1000001))) {
        //var count = 0 //for testing
        //Limits chosen as +or- 0.00001 because user is allowed to enter interest rate of 0.01% granularity (i.e 0.0001)
        while ((solve(lowhigh.0) < -0.00001) || (solve(lowhigh.0) > 0.00001)){
            //for testing
            /*
            count += 1
            print("count \(count)")
            print()
             */
            lowhigh = decimalSearch(lowhigh)
        }
        lowhigh.0 = (lowhigh.0)*100
        return ((lowhigh.0*100).rounded())/100
    }
    
    return -1000001 //handle via error pop-up or similar
    
}



