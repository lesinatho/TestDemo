//
//  UIStoryboardExtension.swift
//
//

import Foundation
import UIKit

extension UIStoryboard {

    // MARK: -  Storyboard 
    fileprivate class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: -  ViewControllers 
    class func profileViewControl() -> ProfileVC {
        return mainStoryboard().instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
    }
}
