//
//  PeersViewController.swift
//  FullEvents
//
//  Created by user on 20/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import AlecrimCoreData

class PeerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailId: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
}

class PeersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var j = false
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    var entityType: ConvType = .user
    
    lazy var fetchTheUsers : FetchRequestController<User> = {
        
        let sortDescriptors = NSSortDescriptor(key: "firstName", ascending: true)
        var query = container.viewContext.users.sort(using: sortDescriptors)
        query.batchSize = 20
        let controller = query.toFetchRequestController()
        return controller
    }()
    
    lazy var fetchTheStreams: FetchRequestController<UserStreams> = {
        
        let sortDescriptorsForStreams = NSSortDescriptor(key: "name", ascending: true)
        let queryParam = container.viewContext.streams.sort(using: sortDescriptorsForStreams)
        
        let controller = queryParam.toFetchRequestController()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDataFromDisc()
    }
    
    func getDataFromDisc() {
        
        do {
            switch entityType {
            case .user:
                try fetchTheUsers.performFetch()
                self.tableView.reloadData()
            case .stream:
                try fetchTheStreams.performFetch()
                self.tableView.reloadData()
            }
        }
        catch{
            
            print("error occured")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "With"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch  entityType {
            
        case .user:
            return fetchTheUsers.numberOfSections()
            
        case .stream:
            return fetchTheStreams.numberOfSections()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch entityType {
            
        case .user :
            return fetchTheUsers.sections[section].numberOfObjects
            
            
        case .stream:
            return fetchTheStreams.sections[section].numberOfObjects
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeerTableViewCell
        
        switch entityType {
            
        case .user:
            
            let userObject = fetchTheUsers.object(at: indexPath)
            
            cell.emailId.isHidden = false
            cell.profilePic.isHidden = false
            cell.name.isHidden = false
            cell.textLabel?.isHidden = true
            
            cell.emailId.text = userObject.login
            
            let firstName = userObject.firstName
            let lastName = userObject.lastName
            let fullName = firstName + lastName
            cell.name.text = fullName
            
            let photoURL = userObject.photoId
            if !photoURL.isEmpty{
                if let imageURL = URL(string: photoURL) {
                    let data = try? Data(contentsOf: imageURL)
                    if let imageData = data {
                        let mediumImage = UIImage(data: imageData)
                        cell.profilePic.image = mediumImage
                        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
                        cell.profilePic.clipsToBounds = true
                        cell.profilePic.layer.borderColor = UIColor.white.cgColor
                        cell.profilePic.layer.borderWidth = 3
                        
                    }
                }
            }
            
        case .stream:
            
            cell.emailId.isHidden = true
            cell.profilePic.isHidden = true
            cell.name.isHidden = true
            cell.textLabel?.isHidden = false
            
            let userStreams = fetchTheStreams.object(at: indexPath)
            cell.textLabel?.text = userStreams.name
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userObject = fetchTheUsers.object(at: indexPath)
        print(userObject.photoId)
        
        if j == false {
            j = true
        } else {
            j = false
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    enum ConvType {
        
        case user
        case stream
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            entityType = .user
            getDataFromDisc()
            
        } else {
            entityType = .stream
            getDataFromDisc()
        }
    }
    
}
