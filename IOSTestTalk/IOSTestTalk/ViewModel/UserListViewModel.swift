//
//  UserListViewModel.swift
//

import Foundation
import UIKit
import CoreData

class UserListViewModel: NSObject {
    
    // MARK: -  Variable Declaration 
    var userlistCellViewModel = [UserListTableCellViewModel]()
    var userlistCellViewModelFilter = [UserListTableCellViewModel]()
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var totalPageSize = 10
    var isSearchActive = false
    var selfController : UIViewController?
    
    // MARK: -  Closture  
    var reloadTableViewClosure : (() -> ())?
    var startIndicator : (() -> ())?
    var stopIndicator : (() -> ())?
    
    // MARK: -  Other 
    var numberOfItemSection : Int {
        return self.userlistCellViewModel.count
    }
    func getSectionCellVM(at indexPath: IndexPath) -> UserListTableCellViewModel {
        return self.userlistCellViewModel[indexPath.row]
    }
    
    // MARK: -  Inti 
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.setOfflineData),
            name: NSNotification.Name(rawValue: "InternetConnectionError"),
            object: nil)
        // API Call
        self.callUserListAPI(page: currentPage)
    }
    
    //MARK: - User list api call -
    func callUserListAPI(page:Int) {
        if isSearchActive {
            return
        }
        if page != 1 {
            self.startIndicator?()
        }else{
            showLoader()
        }
        let param : String = "\(page)&per_page=\(totalPageSize)"
        Network.shared.request(router: .getUserList(body: param)) { (result: Result<[UserListModel], ErrorType>) in
            if page != 1 {
                self.stopIndicator?()
            }else{
                hideLoader()
            }
            guard let res = try? result.get() else {
                return
            }
            if page == 1 {
                self.userlistCellViewModel.removeAll()
                self.userlistCellViewModelFilter.removeAll()
                res.forEach({
                    self.userlistCellViewModel.append(UserListTableCellViewModel(item: $0))
                    self.userlistCellViewModelFilter.append(UserListTableCellViewModel(item: $0))
                })
                self.reloadTableViewClosure?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.storeOfflineData()
                }
            }else{
                if res.count != 0 {
                    res.forEach({
                        self.userlistCellViewModel.append(UserListTableCellViewModel(item: $0))
                    })
                    self.reloadTableViewClosure?()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.storeOfflineData()
                    }
                    
                }else{
                    self.reloadTableViewClosure?()
                    showMessage(text: Messages.somethingwentwrong)
                }
            }
        }
    }
    
    //MARK:- Load more data using pagination
    func loadMoreItemsForList(){
        currentPage = (self.userlistCellViewModel.last?.id)! + 1
        callUserListAPI(page: currentPage)
    }
}


// MARK: -  Store offline data 
extension UserListViewModel {
    
    func storeOfflineData(){
        if userlistCellViewModelFilter.count > 0 {
            for (i, element) in userlistCellViewModelFilter.enumerated(){
                fetchImageFrom(url: element.avatar_url ?? "", index: i)
            }
        }
    }
    
    // MARK: - Fetch image from url
    func fetchImageFrom(url: String,index:Int) {
        let fileName = "picked\(index).jpg"
        let login = userlistCellViewModelFilter[index].login ?? ""
        let type = userlistCellViewModelFilter[index].type ?? ""
        let node_id = userlistCellViewModelFilter[index].node_id ?? ""
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: url) {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        // Now lets store it
                        self.storeImageWith(fileName: fileName, image: image,login: login,type: type, node: node_id)
                    }
                }
            }
        }
    }
    
    // MARK: -  Store image with data 
    func storeImageWith(fileName: String, image: UIImage, login: String, type: String, node: String) {
        if let data = image.jpegData(compressionQuality: 0.5) {
            let documentsURL = FileManager.getDocumentsDirectory()
            let fileURL = documentsURL.appendingPathComponent(fileName)
            do {
                try data.write(to: fileURL, options: .atomic)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.saveOfflineToCoreData(data: data, login: login, type: type, node: node)
                }
            }
            catch {
                print("Unable to Write Data to Disk (\(error.localizedDescription))")
            }
        }
    }
    
    // MARK: -  Save data to coredata database 
    func saveOfflineToCoreData(data:Data, login:String, type: String,node: String)
    {
        let managedContext = objAppDelegate.persistentContainer.viewContext
        
        let user = Userlist(context: managedContext)
        user.login = login
        user.type  = type
        user.avatar_url = data
        user.node_id = node
        objAppDelegate.saveContext()
    }
    
    // MARK: - set offline data
    @objc func setOfflineData()
    {
        hideLoader()
        let arrList = loadUserList()
        for i in arrList {
            var obj = UserListModel()
            obj.login = i.login
            obj.type = i.type
            obj.node_id = i.node_id
            obj.avatar_url = nil
            obj.imgData = i.avatar_url
            self.userlistCellViewModel.append(UserListTableCellViewModel(item: obj))
            self.userlistCellViewModelFilter.append(UserListTableCellViewModel(item: obj))
        }
        self.reloadTableViewClosure?()
    }
    
    // MARK: -  Load offline data from coredata 
    func loadUserList() -> [Userlist] {
        let context = objAppDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Userlist> = Userlist.fetchRequest()
        do {
            let userlist = try context.fetch(request)
            return userlist
        }  catch {
            fatalError("This was not supposed to happen")
        }
    }
    
}

// MARK: -  Tableview Data source and delegate 
extension UserListViewModel : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemSection
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableCell.identifier , for: indexPath) as? UserListTableCell
        let cellVMModelObj = getSectionCellVM(at: indexPath)
        cell?.configureCell(objUser: cellVMModelObj)
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVMModelObj = self.getSectionCellVM(at: indexPath)
        let pvc = UIStoryboard.profileViewControl()
        pvc.strName = cellVMModelObj.login ?? ""
        selfController?.navigationController?.pushViewController(pvc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork(){
            //Pagination logic here
            if !(indexPath.row + 1 < self.userlistCellViewModel.count) {
                self.isLoadingList = true;
                self.loadMoreItemsForList()
            }
        }
    }
}



//MARK:- UIsearch bar delegate methods
extension UserListViewModel : UISearchBarDelegate
{
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.lowercased().count == 0 {
            self.userlistCellViewModel.removeAll()
            isSearchActive = false
            self.userlistCellViewModel = self.userlistCellViewModelFilter
            self.reloadTableViewClosure?()
            searchBar.resignFirstResponder()
            return
        }
        self.userlistCellViewModel.removeAll()
        isSearchActive = true
        self.userlistCellViewModel = self.userlistCellViewModelFilter.filter({ (user) -> Bool in
            if user.login?.lowercased().range(of:searchText.lowercased()) != nil {
                
                return true
            }
            return false
        })
        
        self.reloadTableViewClosure?()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.callUserListAPI(page: 1)
    }
}

