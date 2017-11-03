//
//  PeersViewController.swift
//  FullEvents
//
//  Created by user on 20/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import AlecrimCoreData

protocol PassingContactsAndStreamsDelegate {
    func PassingContacts(contacts: Array<String>)
    func PassingStreams(stream: Array<String>)
}

class PeerTableViewUserCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var checkMark: UIImageView!
}

class PeerTableViewStreamCell: UITableViewCell {
    
    @IBOutlet weak var streamName: UILabel!
    
    @IBOutlet weak var checkMarkForStreams: UIImageView!
    
}

class ContactsAndStreamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarForPeers: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var eventContactsDelegate : PassingContactsAndStreamsDelegate?
    
    
    
    // Search label corresponds to results not found label in storyboard.
    @IBOutlet weak var searchLabel: UILabel!
    var searchBarActive = false
    var searchBarText = String()
    
    var getTheUserObject = User()
    var getTheStreamObject = UserStreams()
    
    // The context defined here corresponds to seach bar and it will be having the filtered contacts and streams.
    var filteredObjectsForUsers = Table<User>(context: container.viewContext)
    var filteredObjectsForStreams = Table<UserStreams>(context: container.viewContext)
    
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
        searchBarForPeers.setShowsCancelButton(false, animated: false)
        searchBarForPeers.delegate = self
        tableView.delegate = self
        self.getDataFromDisc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Attende"
        searchLabel.isHidden = true
        self.tableView.reloadData()
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
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarForPeers.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        switch  entityType {
            
        case .user:
            
            let searchPredicate = NSPredicate(format: "firstName CONTAINS[c] %@ || lastName CONTAINS[c] %@",searchText,searchText)
            
            filteredObjectsForUsers = container.viewContext.users.filter(using: searchPredicate)
            
            searchBarText = searchText
            
            if filteredObjectsForUsers.count() == 0 {
                
                searchBarActive = false
                
            }
            else{
                
                searchBarActive = true
            }
            
            self.tableView.reloadData()
            
        case .stream:
            
            let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            
            filteredObjectsForStreams = container.viewContext.streams.filter(using: searchPredicate)
            
            searchBarText = searchText
            
            if filteredObjectsForStreams.count() == 0 {
                
                searchBarActive = false
                
            }
            else{
                
                searchBarActive = true
            }
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        searchBarText = ""
        searchBar.text = nil
        
        searchBarActive = false
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch  entityType {
            
        case .user:
            if searchBarActive {
                return 1
            } else {
                return fetchTheUsers.numberOfSections()
            }
            
        case .stream:
            if searchBarActive {
                return 1
            } else {
                return fetchTheStreams.numberOfSections()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch entityType {
            
        case .user :
            if searchBarActive {
                return filteredObjectsForUsers.execute().count
            } else {
                return fetchTheUsers.sections[section].numberOfObjects
            }
            
        case .stream:
            if searchBarActive {
                return filteredObjectsForStreams.execute().count
            } else {
                return fetchTheStreams.sections[section].numberOfObjects
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch entityType {
            
        case .user:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! PeerTableViewUserCell
            
            if searchBarActive {
                getTheUserObject = filteredObjectsForUsers.execute()[indexPath.row]
            } else {
                getTheUserObject = fetchTheUsers.object(at: indexPath)
            }
            
            if (filteredObjectsForUsers.count() == 0 && !searchBarText.isEmpty) {
                cell.isHidden = true
                searchLabel.isHidden = false
            } else {
                searchLabel.isHidden = true
            }
            
            
            let firstName = getTheUserObject.firstName
            let lastName = getTheUserObject.lastName
            let fullName = firstName + lastName
            cell.name.text = fullName
            
            let photoURL = getTheUserObject.photoId
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
                let profileImage = #imageLiteral(resourceName: "PersonDummyImage")
                circularImage(profileImage: profileImage, cell: cell)
                
            }
            
            let userId = getTheUserObject.id
            if userIds.contains(userId) {
                cell.checkMark.isHidden = false
            } else {
                cell.checkMark.isHidden = true
            }
            
            return cell
            
        case .stream:
            
            let streamCell = tableView.dequeueReusableCell(withIdentifier: "StreamCell", for: indexPath) as! PeerTableViewStreamCell
            
            if searchBarActive {
                getTheStreamObject = filteredObjectsForStreams.execute()[indexPath.row]
                
            } else {
                getTheStreamObject = fetchTheStreams.object(at: indexPath)
                
            }
            
            if (filteredObjectsForStreams.count() == 0 && !searchBarText.isEmpty) {
                streamCell.isHidden = true
                searchLabel.isHidden = false
            } else {
                searchLabel.isHidden = true
            }
            
            streamCell.streamName.text = getTheStreamObject.name
            
            let streamId = getTheStreamObject.id
            
            if streamIds.contains(streamId) {
                streamCell.checkMarkForStreams.isHidden = false
            }  else {
                streamCell.checkMarkForStreams.isHidden = true
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
    
    func selectingContacts() {
        let userId = getTheUserObject.id
        
        if userIds.contains(userId) {
            if let index = userIds.index(of: userId) {
                userIds.remove(at: index)
            }
        } else {
            userIds.append(userId)
        }
        tableView.reloadData()
    }
    
    func selectingStreams() {
        let streamId = getTheStreamObject.id
        
        if streamIds.contains(streamId) {
            if let index = streamIds.index(of: streamId) {
                streamIds.remove(at: index)
            }
        } else {
            streamIds.append(streamId)
            if streamIds.count > 1 {
                streamIds.removeFirst(streamIds.count - 1)
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBarForPeers.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch entityType {
        case .user:
            
            if searchBarActive {
                getTheUserObject = filteredObjectsForUsers.execute()[indexPath.row]
            }
                
            else {
                
                getTheUserObject = fetchTheUsers.object(at: indexPath)
            }
            selectingContacts()
            
        case .stream:
            
            if searchBarActive {
                getTheStreamObject = filteredObjectsForStreams.execute()[indexPath.row]
            } else {
                getTheStreamObject = fetchTheStreams.object(at: indexPath)
            }
            selectingStreams()
            if streamIds != [] {
                let contactNames = UserService.getContactUsingId(contactId: userIds)
                eventContactsDelegate?.PassingContacts(contacts: contactNames)
                let selectedStream = StreamService.getSelectedStream(streamId: streamIds)
                eventContactsDelegate?.PassingStreams(stream: selectedStream)
                guard let eventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController else {
                    return
                }
                guard let parent = navigationController?.parent as? EventBaseViewController else {
                    return
                }
                eventDetailsViewController.eventInfo = parent.event
                navigationController?.pushViewController(eventDetailsViewController, animated: true)
            }
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
