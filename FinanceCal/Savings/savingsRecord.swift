//
//  savingsRecord.swift
//  FinanceCal
//
//  Created by Rehanga Gamage on 2023-07-28.
//

import Foundation

class savingsRecord : NSObject, NSCoding {
    
    var x: Double
    var m: Double
    var n: Double
    var a: Double
    var monthEnd: Bool
    var y: Double
    var notes: String
    
    init?(x: Double, m: Double, n: Double, a: Double, monthEnd: Bool, y: Double, notes: String){
        
        self.x = x
        self.m = m
        self.n = n
        self.a = a
        self.monthEnd = monthEnd
        self.y = y
        self.notes = notes
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savingsSave")
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(x, forKey: "x")
        aCoder.encode(m, forKey: "m")
        aCoder.encode(n, forKey: "n")
        aCoder.encode(a, forKey: "a")
        aCoder.encode(monthEnd, forKey: "monthEnd")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(notes, forKey: "notes")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let x = aDecoder.decodeDouble(forKey: "x")
        let m = aDecoder.decodeDouble(forKey: "m")
        let n = aDecoder.decodeDouble(forKey: "n")
        let a = aDecoder.decodeDouble(forKey: "a")
        let monthEnd = aDecoder.decodeBool(forKey: "monthEnd")
        let y = aDecoder.decodeDouble(forKey: "y")
        let notes = aDecoder.decodeObject(forKey: "notes") as? String
        
        self.init(x: x,m: m,n: n,a: a,monthEnd: monthEnd,y: y,notes: notes!)
    }
}
