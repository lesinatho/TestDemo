//
//  MixExtension.swift
//

import Foundation
import UIKit


extension FileManager {
    static func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
 }
}

extension UIViewController {
    func showToastMessage(message : String) {
        let font = UIFont.systemFont(ofSize: 17)
        let width = self.view.frame.size.width - 40//self.view.frame.size.width - 40
        let height = heightForViewlabel(text: message, font: font, width: width)
        print("get cell height ----------------\(height)")
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-60, width:width , height: CGFloat(message.count + 10)))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 17)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = CGFloat(message.count + 10) / 2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func heightForViewlabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

