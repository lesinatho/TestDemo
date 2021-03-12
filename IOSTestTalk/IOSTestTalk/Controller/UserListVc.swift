//
//  ViewController.swift
//

import UIKit
import CoreData

class UserListVc: UIViewController {
    
    // MARK: -  IBOutlets 
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet weak var footerloading: UIView!
    @IBOutlet weak var avLoading: UIActivityIndicatorView!
    
    // MARK: -  Variables 
    let tblUserList = UITableView()
    var arrUserList = [UserListModel]()
    var arrFilteredData = [UserListModel]()
    var viewModelObj = UserListViewModel()
   
    // MARK: -  Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        searchBar.resignFirstResponder()
    }
    
    // MARK: -  Custom methods 
    func setUp(){
        self.setupTableView()
        
        searchBar.delegate = viewModelObj // Searchbar delegate assign to viewmodel
        
        viewModelObj.selfController = self
        viewModelObj.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async { self!.tblUserList.reloadData() }
        }
        viewModelObj.startIndicator = { [weak self] () in
            self?.avLoading.isHidden = false
            self?.avLoading.startAnimating()
        }
        viewModelObj.stopIndicator = { [weak self] () in
            self?.avLoading.isHidden = true
            self?.avLoading.stopAnimating()
        }
    }
    
    
    // MARK: -  Tableview setup 
    func setupTableView() {
        view.addSubview(tblUserList)
        tblUserList.translatesAutoresizingMaskIntoConstraints = false
        tblUserList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tblUserList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tblUserList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tblUserList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tblUserList.estimatedRowHeight = 100
        tblUserList.rowHeight = UITableView.automaticDimension
        tblUserList.register(UserListTableCell.nib, forCellReuseIdentifier: UserListTableCell.identifier)
        tblUserList.tableHeaderView = searchBar
        tblUserList.tableHeaderView?.backgroundColor = backgroundColor
        tblUserList.tableFooterView = footerloading
        tblUserList.dataSource = viewModelObj
        tblUserList.delegate = viewModelObj
      }
    
}
