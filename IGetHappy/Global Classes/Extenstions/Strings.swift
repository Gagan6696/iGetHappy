//
//  Strings.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    
    
    
    func toDouble() -> Double?
    {
        return Double.init(self)
    }
    func toFloat() -> Float?
    {
        return Float.init(self)
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isNumber: Bool{
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
            var filtered:String!
        let inputString:NSArray = self.components(separatedBy: charcter) as NSArray
        filtered = inputString.componentsJoined(by: "") as NSString as String
            return  self == filtered
//        let numberRegEx  = ".*[0-9]+.*"
//        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
//        return texttest1.evaluate(with:self)
    }
    
    ///
    /// Replaces multiple occurences of strings/characters/substrings with their associated values.
    /// ````
    /// var string = "Hello World"
    /// let newString = string.replacingMultipleOccurrences(using: (of: "l", with: "1"), (of: "o", with: "0"), (of: "d", with: "d!"))
    /// print(newString) //"He110 w0r1d!"
    /// ````
    ///
    /// - Returns:
    /// String with specified parts replaced with their respective specified values.
    ///
    /// - Parameters:
    ///     - array: Variadic values that specify what is being replaced with what value in the given string
    ///
    
    func replacingMultipleOccurrences<T: StringProtocol, U: StringProtocol>(using array: (of: T, with: U)...) -> String {
        var str = self
        for (a, b) in array {
            str = str.replacingOccurrences(of: a, with: b)
        }
        return str
    }
    
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    func MinimumRangeofTextFieldValue(minCharCount : Any, value: Any?) -> Bool
    {
        if let str = value as? String
        {
            let intCount = minCharCount as! Int
            
            if str.underestimatedCount < intCount
            {
                print("character is less then the count")
                return false
            }
            else
            {
                print("character is greater then the count")
                return true
            }
            
        }
        else if let intvalue = value as? Int
        {
            let intCount = minCharCount as! Int
            
            if intvalue.nonzeroBitCount < intCount
            {
                print("int is less then the count")
                return false
            }
            else
            {
                print("int is greater then the count")
                return true
            }
            
            
        }
        else if let floatvalue = value as? Float
        {
            print("This is the float value \(floatvalue)")
            
            if floatvalue.isLessThanOrEqualTo(floatvalue)
            {
                print("Value is less")
                return false
            }
            else
            {
                print("value is grater")
                return true
            }
        }
        return false
    }
    
    var nameMinLength : Bool
    {
        if self.count >= 3 && self.count <= 20
        {
            return true
        }
        return false
    }
    var phoneMinLength : Bool
    {
        if self.count >= 8 && self.count <= 12
        {
            return true
        }
        return false
    }
    var emailMinLength : Bool
    {
        if self.count<=50
        {
            return true
        }
        return false
    }
    var postMaxLength : Bool
    {
        if self.count <= 100
        {
            return true
        }
        return false
    }
    var passwordMinLength : Bool
    {
        if self.count >= 7
        {
            return true
        }
        return false
    }
    
    
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
  
    
    func checkTextSufficientComplexity() -> Bool{
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        print("\(numberresult)")
        //
        //          let specialSymbolRegEx  =   ".*[^A-Za-z0-9].*"
        //        let texttest2 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        //        let specialSymbolresult = texttest1.evaluate(with: self)
        //        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialSymbolresult = texttest2.evaluate(with: self)
        print("\(numberresult)")
        //  let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        //    let specialresult = texttest2.evaluate(with: text)
        //       print("\(specialresult)")
        
        // return capitalresult || numberresult || specialresult
        return capitalresult && numberresult && specialSymbolresult
        
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
}


