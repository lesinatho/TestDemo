//
//  Utilities.swift
//

import Foundation
import UIKit
import Photos
import PhotosUI

class Utilities
{
    // MARK: -  Sharable Instance  
    static var shared = Utilities()
    
    var notiToastString : ((String) -> ())?
    var notifycheckCamera : (() -> ())?
    var socketConnected : (() -> ())?
    var notifyListUpdate: ((Int) -> ())?
    var redirectNotificationClosure : ((String, Int) -> ())?
    
    class func showNoDataFoundLabel(tableview:UITableView, strMsg : String) -> Int{
         let noDataLabel = UILabel()
         noDataLabel.textAlignment = .center
         noDataLabel.text = strMsg
         noDataLabel.center = tableview.center
         noDataLabel.font = UIFont.systemFont(ofSize: 15)
         noDataLabel.textColor = .darkGray
         tableview.backgroundView = noDataLabel
         return 0
     }
}
