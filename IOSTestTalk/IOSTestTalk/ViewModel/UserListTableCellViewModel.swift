//
//  UserListTableCellViewModel.swift
//

// MARK: -  Listcell ViewModel 

import Foundation

class UserListTableCellViewModel {
    
    // MARK: -  Variable Declaration 
    var listModelObj : UserListModel!
    
    var id: Int? {
        return self.listModelObj.id
    }
    var login: String? {
        return self.listModelObj.login
    }
    var node_id: String? {
        return self.listModelObj.node_id
    }
    var avatar_url : String? {
        return self.listModelObj.avatar_url
    }
    var imgData : Data? {
        return self.listModelObj.imgData
    }
    var type : String? {
        return self.listModelObj.type
    }
    var note : String? {
        return self.listModelObj.note
    }
    
    // MARK: -  init 
    init(item:UserListModel) {
        self.listModelObj = item
    }
    
}
