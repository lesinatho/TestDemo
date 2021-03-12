//
//  ProfileViewModel.swift
//

import Foundation
import CoreData
import UIKit

class ProfileViewModel : NSObject {
    
    // MARK: -  Variable Declaration 
    var objProfile : UserProfileModel?
    var strName : String?
    var id, followers, following: Int?
    var login, avatar_url, url, html_url, followers_url, following_url, gists_url, starred_url, subscriptions_url, organizations_url, repos_url, events_url, received_events_url, type, node_id, gravatar_id,company, blog,name, note: String?
    var img : Data?
    
    // MARK: -  Closture 
    var reloadreloadUpdateUIClosure : (() -> ())?
    
    // MARK: -  Init 
    init(profileName : String) {
        super.init()
        self.strName = profileName
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loadOfflineData),
            name: NSNotification.Name(rawValue: "InternetConnectionError"),
            object: nil)
        self.callProfileAPI() // API Call
    }
    
    // MARK: -  API  
    func callProfileAPI() {
        showLoader()
        let param : String = "\(strName ?? "")"
        Network.shared.request(router: .getUserProfile(body: param)) { (result: Result<UserProfileModel, ErrorType>) in
            hideLoader()
            guard let res = try? result.get() else {
                return
            }
            self.objProfile = res
            self.setProfileModel()
        }
    }
    
    // MARK: -  SetData in viewmodel obj  
    func setProfileModel() {
        self.id = self.objProfile?.id
        self.followers = self.objProfile?.followers
        self.following = self.objProfile?.following
        self.login = self.objProfile?.login
        self.avatar_url = self.objProfile?.avatar_url
        self.url = self.objProfile?.url
        self.followers_url = self.objProfile?.followers_url
        self.gists_url = self.objProfile?.gists_url
        self.starred_url = self.objProfile?.starred_url
        self.subscriptions_url = self.objProfile?.subscriptions_url
        self.organizations_url = self.objProfile?.organizations_url
        self.repos_url = self.objProfile?.repos_url
        self.events_url = self.objProfile?.events_url
        self.received_events_url = self.objProfile?.received_events_url
        self.type = self.objProfile?.type
        self.node_id = self.objProfile?.node_id
        self.gravatar_id = self.objProfile?.gravatar_id
        self.company = self.objProfile?.company
        self.blog = self.objProfile?.blog
        self.name = self.objProfile?.name
        self.note = self.objProfile?.note
        self.reloadreloadUpdateUIClosure?()
    }
    
    // MARK: -  load offline data with predicate 
    @objc func loadOfflineData(){
        hideLoader()
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "login contains[c] '\(strName ?? "")'")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Profile")
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            for data in result {
                print("data----------\(data)")
                if strName == data.value(forKey: "login") as? String ?? ""
                {
                    self.name = data.value(forKey: "name") as? String
                    self.login = data.value(forKey: "login") as? String
                    self.note = data.value(forKey: "note") as? String
                    self.blog = data.value(forKey: "blog") as? String
                    self.company = data.value(forKey: "company") as? String
                    self.following = Int(data.value(forKey: "following") as? String ?? "0")
                    self.followers = Int(data.value(forKey: "followers") as? String ?? "0")
                    self.img =  data.value(forKey: "avatar_url") as? Data
                    self.reloadreloadUpdateUIClosure?()
                    break
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    
    // MARK: -  Store offline profile data 
    func storeOfflineData(imgData:Data,note:String?){
        //We need to create a context from this container
        let managedContext = objAppDelegate.persistentContainer.viewContext
        let user = Profile(context: managedContext)
        user.login = objProfile?.login ?? ""
        user.blog = objProfile?.blog ?? ""
        user.company = objProfile?.company ?? ""
        user.name = objProfile?.name ?? ""
        user.followers = "\(objProfile?.followers ?? 0)"
        user.following = "\(objProfile?.following ?? 0)"
        user.type  = objProfile?.type ?? ""
        user.avatar_url = imgData
        objAppDelegate.saveContext()
    }
    
    
    // MARK: -  set Online data
    
    // MARK: -  download asynchornous image
    func downloadImageAsync(strURL:String,notes:String?){
        if let url = URL(string: strURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    self.storeOfflineData(imgData: data, note: notes)
                }
            }
            task.resume()
        }
    }
    
    //MARK: update data with textview note data
    func updateProfileData(notes:String) {
        var managedContext:NSManagedObjectContext!
        managedContext = objAppDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(login = %@)", self.strName!)
        request.predicate = predicate
        do {
            let results =
                try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue(notes, forKey: "note")
            do {
                try managedContext.save()
                HBToast.showBottomMessage(backgroundColor: TextColor  , textColor: backgroundColor, message: Messages.updateRecord)
                
            }catch let error as NSError {
                HBToast.showBottomMessage(backgroundColor: TextColor  , textColor: backgroundColor, message: error.description)
            }
        }
        catch let error as NSError {
            HBToast.showBottomMessage(backgroundColor: TextColor  , textColor: backgroundColor, message: error.description)
        }
    }
}

