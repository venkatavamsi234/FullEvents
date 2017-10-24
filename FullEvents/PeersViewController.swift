//
//  PeersViewController.swift
//  FullEvents
//
//  Created by user on 20/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import AlecrimCoreData

class PeerTableViewUserCell: UITableViewCell {
    
    @IBOutlet weak var emailId: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var checkMark: UIImageView!
}

class PeerTableViewStreamCell: UITableViewCell {
    
    @IBOutlet weak var streamName: UILabel!
    
    @IBOutlet weak var checkMarkForStreams: UIImageView!
    
}

class PeersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var searchBarForPeers: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    var entityType: ConvType = .user
    var userIds:[String] = []
    var streamIds:[String] = []
    
    lazy var fetchTheUsers : FetchRequestController<User> = {
        let predicate:NSPredicate = NSPredicate(format: "status == %@","ACTIVE")
        let sortDescriptors = NSSortDescriptor(key: "firstName", ascending: true)
        var query = container.viewContext.users.filter(using: predicate).sort(using: sortDescriptors)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarForPeers.endEditing(true)
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
        navigationController?.navigationBar.topItem?.title = "Attende"
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
        
        switch entityType {
            
        case .user:
            
            let userObject = fetchTheUsers.object(at: indexPath)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! PeerTableViewUserCell
            
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
                        if let mediumImage = UIImage(data: imageData) {
                            circularImage(profileImage: mediumImage, cell: cell)
                        }
                    }
                }
            } else {
                let profileImage = #imageLiteral(resourceName: "icons8-Male User-40")
                circularImage(profileImage: profileImage, cell: cell)
                
            }
            
            let userId = userObject.id
            if userIds.contains(userId) {
                cell.checkMark.isHidden = false
            } else {
                cell.checkMark.isHidden = true
            }
            return cell
            
        case .stream:
            
            let userStream = fetchTheStreams.object(at: indexPath)
            let streamCell = tableView.dequeueReusableCell(withIdentifier: "StreamCell", for: indexPath) as! PeerTableViewStreamCell
            
            streamCell.streamName.text = userStream.name
            
            print("stream name \(userStream.name)")
            
            let streamId = userStream.id
            
            if streamIds.contains(streamId) {
                print(streamId)
                
                print(indexPath)
                streamCell.checkMarkForStreams.isHidden = false
                print("checkmark selected")
            } else {
                streamCell.checkMarkForStreams.isHidden = true
                print("checkmark not selected")
            }
            
            return streamCell
        }
        
    }
    
    func circularImage(profileImage : UIImage, cell: PeerTableViewUserCell) {
        cell.profilePic.image = profileImage
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        cell.profilePic.layer.borderColor = UIColor.white.cgColor
        cell.profilePic.layer.borderWidth = 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarForPeers.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        switch entityType {
        case .user:
            
            let userObject = fetchTheUsers.object(at: indexPath)
            let userId = userObject.id
            
            if userIds.contains(userId) {
                if let index = userIds.index(of: userId) {
                    userIds.remove(at: index)
                    print("userid is:", userIds)
                }
            } else {
                userIds.append(userId)
                print(userIds)
            }
            
            tableView.reloadData()
            
        case .stream:
            
            let streamObject = fetchTheStreams.object(at: indexPath)
            let streamId = streamObject.id
            
            if streamIds.contains(streamId) {
                if let index = streamIds.index(of: streamId) {
                    streamIds.remove(at: index)
                    print("userStreams is:", streamIds)
                }
            } else {
                streamIds.append(streamId)
                if streamIds.count > 1 {
                    streamIds.removeFirst(streamIds.count - 1)
                }
            }
            
            print("Stream ID selected \(streamIds)")
            
            tableView.reloadData()
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
