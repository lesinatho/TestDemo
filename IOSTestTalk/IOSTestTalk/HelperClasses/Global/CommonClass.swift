//
//  CommonClass.swift
//

import Foundation
import UIKit
import AVFoundation
import CoreGraphics

private let _sharedInstance = CommonClass()

class CommonClass : NSObject {
    
    class var sharedInstance: CommonClass {
        return _sharedInstance
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // For Get Color Using HexCode
    func getColorIntoHex(Hex:String) -> UIColor {
        if Hex.isEmpty {
            return UIColor.clear
        }
        let scanner = Scanner(string: Hex)
        //scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return UIColor.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
    
    //MARK:- User default
    func saveDefault(withObject: AnyObject ,forkey:String)
    {
        let deft = UserDefaults.standard
        deft.set(withObject, forKey: forkey)
        deft.synchronize()
    }
    
    func getDefault(forkey:String) -> AnyObject?
    {
        let deft = UserDefaults.standard
        return (deft.value(forKey: forkey) as AnyObject?) ?? nil
    } 
}


