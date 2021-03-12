//
//  ProfileVC.swift
//

import UIKit
import CoreData

class ProfileVC: UIViewController {
    // MARK: -  IBOutlets 
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblFollowers : UILabel!
    @IBOutlet var lblNavTitle : UILabel!
    @IBOutlet var lblFollowing : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCompany : UILabel!
    @IBOutlet var lblBlog : UILabel!
    @IBOutlet var txtNotes : UITextView!
    
    
    // MARK: -  Variables 
    var strName = ""
    var objProfileViewModel: ProfileViewModel? {
        didSet {
            fillUI()
        }
    }
    
    // MARK: -  Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
    }
    func setUp(){
        self.flushData()
        lblNavTitle.text = strName
        txtNotes.layer.borderWidth = 0.5
        txtNotes.layer.borderColor = UIColor.lightGray.cgColor
        txtNotes.layer.cornerRadius = 4
        txtNotes.layer.masksToBounds = true
        
        objProfileViewModel = ProfileViewModel(profileName: strName) // pass data to viewmodel obj
        // Refresh UI
        objProfileViewModel?.reloadreloadUpdateUIClosure = { [weak self] () in
            self?.fillUI()
        }
    }
    
    // MARK: -  Clear dummy data  
    func flushData(){
        lblFollowing.text = ""
        lblFollowers.text = ""
        lblBlog.text = ""
        lblCompany.text = ""
        lblName.text = ""
        txtNotes.text = ""
    }
    
    // MARK: -  Dsiplay in UI From  Viewmodel obj  
    fileprivate func fillUI(){
        lblName.text = objProfileViewModel?.strName
        lblBlog.text = objProfileViewModel?.blog
        lblCompany.text = objProfileViewModel?.company
        txtNotes.text = objProfileViewModel?.note
       
        if objProfileViewModel?.following != 0{
            lblFollowing.text = "Followings: \(objProfileViewModel?.following ?? 0)"
        }else{
            lblFollowing.text = ""
        }
        
        if objProfileViewModel?.followers != 0{
            lblFollowers.text = "Followers: \(objProfileViewModel?.followers ?? 0)"
        }else{
            lblFollowers.text = ""
        }
        
        if  objProfileViewModel?.img != nil {
            let imgData = objProfileViewModel?.img
            DispatchQueue.main.async { /// execute on main thread
                self.imgUser.image = UIImage(data: (imgData!) as Data)
            }
        }
        else{
            objProfileViewModel?.downloadImageAsync(strURL: objProfileViewModel?.avatar_url ?? "", notes: txtNotes.text ?? "")
            self.imgUser.downloaded(from: objProfileViewModel?.avatar_url ?? "")
        }
        
    }
    
    // MARK: -  Button action methods
    @IBAction func btnBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender:UIButton){
        if txtNotes.text.isEmpty == false {
            objProfileViewModel?.updateProfileData(notes: txtNotes.text)
        }
    }
    
}
