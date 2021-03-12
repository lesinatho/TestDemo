//
//  UserListTableself.swift
//

import UIKit
import CoreData

class UserListTableCell: UITableViewCell {
    
    // MARK: -  Outlets 
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet weak var ivNote: UIImageView!
    
    
    // MARK: -  Init 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.layer.masksToBounds = true
    }
    
    // MARK: -  Cell reused then call 
    override func prepareForReuse() {
        self.lblName.text = ""
        self.lblDetails.text = ""
        self.imgUser.image = nil
    }
    
    // MARK: -  Cell configure from viewmodel 
    func configureCell(objUser:UserListTableCellViewModel){
        self.lblName.text = objUser.login
        self.lblDetails.text = objUser.node_id
        if objUser.note?.isEmpty == false {
            self.ivNote.isHidden = false
        }
        if objUser.avatar_url == nil{
            // execute on main thread
            DispatchQueue.main.async {
                self.imgUser.image = UIImage(data: objUser.imgData! as Data)
            }
        }else{
            downloadImageAsync(strURL: objUser.avatar_url ?? "")
        }
    }
    
    // MARK: -  Download image and load 
    func downloadImageAsync(strURL:String)
    {
        if let url = URL(string: strURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.imgUser.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }else{
            self.imgUser.image = UIImage(named: "ic_user")
        }
    }
}

// MARK: -  For using identifier and nib 
extension UserListTableCell: CellIdentifiable {}
