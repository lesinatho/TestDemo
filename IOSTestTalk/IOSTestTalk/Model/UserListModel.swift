//
//  UserListModel.swift
//  iOSDevTest
//

import UIKit
import Foundation
import CoreData

// MARK: -  User model info 
struct UserListModel : Codable {
    var id: Int?
    var login, avatar_url, url, html_url, followers_url, following_url, gists_url, starred_url, subscriptions_url, organizations_url, repos_url, events_url, received_events_url, type, node_id, gravatar_id, note: String?
    var imgData : Data?
}

// MARK: -  User Data model info 
struct UserListModelResponse : Codable {
    let data: [UserListModel]?
}

// MARK: -  User Profile response datamodel 
struct UserProfileModelResponse : Codable {
    let data: UserProfileModel?
}

// MARK: -  User Profile model 
struct UserProfileModel : Codable {
    var id, followers, following: Int?
    var login, avatar_url, url, html_url, followers_url, following_url, gists_url, starred_url, subscriptions_url, organizations_url, repos_url, events_url, received_events_url, type, node_id, gravatar_id,company, blog,name, note: String?
}

// MARK: -  -------------------------------------------------------------------------------------------------------------------------------------------- 



// MARK: -  CoreData model  

//MARK:- Userlist
@objc(Userlist)
final class Userlist: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var login, type, node_id: String
    @NSManaged var avatar_url : Data
    
}

extension Userlist {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Userlist> {
        return NSFetchRequest<Userlist>(entityName: "Userlist")
    }
}

//MARK:- Profile
@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var login, type,company, blog, name, note,followers, following: String
    @NSManaged var avatar_url : Data
}

extension Profile {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }
}
