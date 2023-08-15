//
//  savingsRecord.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import Foundation

class mortgageRecord : NSObject, NSCoding {
    
    var x: Double
    var m: Double
    var n: Double
    var a: Double
    var notes: String
    
    init?(x: Double, m: Double, n: Double, a: Double, notes: String){
        
        self.x = x
        self.m = m
        self.n = n
        self.a = a
        self.notes = notes
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mortgageSave")
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(x, forKey: "xl")
        aCoder.encode(m, forKey: "ml")
        aCoder.encode(n, forKey: "nl")
        aCoder.encode(a, forKey: "al")
        aCoder.encode(notes, forKey: "notesl")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let x = aDecoder.decodeDouble(forKey: "xl")
        let m = aDecoder.decodeDouble(forKey: "ml")
        let n = aDecoder.decodeDouble(forKey: "nl")
        let a = aDecoder.decodeDouble(forKey: "al")
        let notes = aDecoder.decodeObject(forKey: "notesl") as? String
        
        self.init(x: x,m: m,n: n,a: a,notes: notes!)
    }
}
