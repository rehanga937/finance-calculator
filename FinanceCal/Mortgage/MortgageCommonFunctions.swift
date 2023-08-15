//
//  MortgageCommonFunctions.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-30.
//

import Foundation

//All functions can be borrowed from LoanCommonFunction. Loans and mortgages are functionally the same - it's just that loans are implemented with monthly granularity and mortgages with annual granularity, so the calculation functions can be shared. Only discrepancy is that in a mortgage the payment is still given monthly so in some cases we have to multiply or divide by 12. This has been done in required parts of the code and has been commented as : "//since mortgage is an annual granularity loan but with payments calculated monthly". The only exception is for the mortgageSolveForPaymentValue which is on this file.

func mortgageSolveForPaymentValue (InitialValue x: Double, InterestRatePA m_old: Double, numberOfMonths n: Double) -> Double{
    var a: Double
    let m = m_old/100
    
    a = x*m + x*m/(-1+pow((1+m),n))
    a = a/12 //since mortgage is an annual granularity loan but with payments calculated monthly
    
    return ((a*100).rounded())/100
}
