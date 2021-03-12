//
//  HBToast.swift
//
import Foundation
import UIKit

class HBToast: NSObject
{
    static let shared = HBToast()
    var notifView = UIView()
    
    class private func showAlertBottom(backgroundColor:UIColor, textColor:UIColor, message:String)
    {
        let _: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let windowFrame :CGRect = UIScreen.main.bounds.self
        let windows = UIApplication.shared.windows
        //windows.last?.makeToast("toast message")
        
        var messageLabel: UILabel?
        let wrapperView = UIView()
        
        messageLabel = UILabel()
        messageLabel?.text = message
        messageLabel?.numberOfLines = 0
        messageLabel?.font = UIFont.systemFont(ofSize: 15.0)
        messageLabel?.textAlignment = NSTextAlignment.center
        messageLabel?.lineBreakMode = .byTruncatingTail;
        messageLabel?.textColor = textColor
        messageLabel?.backgroundColor = UIColor.clear
        
        let maxMessageSize = CGSize(width: (windowFrame.size.width * 0.8), height: windowFrame.size.height * 0.8)
        let messageSize = messageLabel?.sizeThatFits(maxMessageSize)
        if let messageSize = messageSize {
            let actualWidth = min(messageSize.width, maxMessageSize.width)
            let actualHeight = min(messageSize.height, maxMessageSize.height)
            messageLabel?.frame = CGRect(x: 10.0, y: 10.0, width: actualWidth, height: actualHeight)
        }
        
        let messageRect:CGRect = (messageLabel?.frame)!
        wrapperView.backgroundColor = backgroundColor
        wrapperView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        wrapperView.layer.cornerRadius = 10
        let wrapperWidth = messageRect.size.width + messageRect.origin.x + 10
        let wrapperHeight = messageRect.origin.y + messageRect.size.height + 10
        
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        messageLabel?.frame = messageRect
        wrapperView.addSubview(messageLabel!)
        wrapperView.center = CGPoint(x: windowFrame.size.width / 2.0, y: windowFrame.size.height - (wrapperView.frame.size.height / 2.0) - 60)
        wrapperView.alpha = 0.4
        windows.last?.addSubview(wrapperView)
        // appDelegate.window?.addSubview(wrapperView)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            wrapperView.alpha = 1.0
        }) { _ in
            wrapperView.removeFromSuperview()
        }
    }
    
    class func showBottomMessage(message:String)
    {
        showAlertBottom(backgroundColor: UIColor.black, textColor: UIColor.white, message: message)
    }
    class func showBottomMessage(backgroundColor: UIColor, textColor: UIColor, message: String)
    {
        showAlertBottom(backgroundColor: backgroundColor, textColor: textColor, message: message)
    }
    
}


