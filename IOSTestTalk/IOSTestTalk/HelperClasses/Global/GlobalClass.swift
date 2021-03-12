//
//  GlobalClass.swift
//

import Foundation
import UIKit

// MARK: -  Screen  
let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
let SCREEN_WIDTH        = UIScreen.main.bounds.size.width
let SCREEN_SIZE         = UIScreen.main.bounds.size

// MARK: -  GLOBAL METHODS  
var objAppDelegate    : AppDelegate!

func showLoader(){
    hideLoader()
    DispatchQueue.main.async {
        if let w = SceneDelegate.shared?.window {
            let loaderContainer = UIView(frame: w.bounds)
            loaderContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            loaderContainer.tag = Int.max
            let w_h : CGFloat = 100.0
            let indicator = UIActivityIndicatorView(frame: CGRect(x: (SCREEN_WIDTH - w_h)/2, y: (SCREEN_HEIGHT - w_h)/2, width: w_h, height: w_h))
            indicator.color = UIColor.white//.withAlphaComponent(0.4)
            indicator.style = UIActivityIndicatorView.Style.large
            indicator.startAnimating()
            loaderContainer.addSubview(indicator)
            w.addSubview(loaderContainer)
        }
    }
}

func hideLoader() {
    DispatchQueue.main.async {
        if let w = SceneDelegate.shared?.window {
            if let loader = w.viewWithTag(Int.max) {
                loader.removeFromSuperview()
            }
        }
    }
}


func showMessage(text:String)
{
    if Utilities.shared.notiToastString != nil {
        Utilities.shared.notiToastString!(text)
    }
}
