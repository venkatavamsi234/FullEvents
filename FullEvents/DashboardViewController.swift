//
//  DashboardViewController.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlecrimCoreData

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var view: UIView!
    
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTableView: UITableView!
    var getTheEvent = Event()
    
    lazy var fetchTheEvents: FetchRequestController<Event> = {
        let sortDescriptorsForEvents = NSSortDescriptor(key: "startDate", ascending: true)
        let queryParam = container.viewContext.events.sort(using: sortDescriptorsForEvents)
        let controller = queryParam.toFetchRequestController(sectionNameKeyPath: #keyPath(Event.day), cacheName: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        fetchTheEvents.bind(to: self.eventsTableView)
        getDataFromDisc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Events"
        eventsTableView.tableFooterView = UIView()
    }
    
    func getDataFromDisc() {
        do {
            try fetchTheEvents.performFetch()
            print("no of sections \(fetchTheEvents.sections.count)")
        } catch {
            print("error is: \(error)")
        }
    }
    
    @IBAction func addingEvents(_ sender: Any) {
        
        guard let eventBaseViewController = storyboard?.instantiateViewController(withIdentifier: "EventBaseViewController") as? EventBaseViewController else {
            return
        }
        self.navigationController?.present(eventBaseViewController, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchTheEvents.numberOfSections()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchTheEvents.sections[section].numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! EventsTableViewCell
        
        getTheEvent = fetchTheEvents.object(at: indexPath)
        
        //   converting longmilli sec to date object
        let date = Date(timeIntervalSince1970: (Double((getTheEvent.startDate)) / 1000.0))
        let startDateString = dateConversionToString(date: date)
        cell.eventName.text = getTheEvent.eventName.capitalized
        cell.eventDescription.text = getTheEvent.eventDescrip
        cell.eventStartTime.text = startDateString
        let duration = getTheEvent.duration
        
        if duration > 59 {
            let timeHr = duration / 60
            let timeMin = duration % 60
            cell.eventDuration.text = "\(timeHr)" + "h" + " " + "\(timeMin)" +  " mins"
        } else {
            cell.eventDuration.text = "\(duration)" + " mins"
        }
        
        cell.view.layer.cornerRadius = 5
        cell.view.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventsTableView.deselectRow(at: indexPath, animated: true)
        guard let eventDetailsVC = storyboard?.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController else{
            return
        }
        navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
    
    //   converting date to date string
    func dateConversionToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.eventsTableView.frame.width, height: self.eventsTableView.sectionHeaderHeight))
        self.view.addSubview(view)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.eventsTableView.frame.width, height: self.eventsTableView.sectionHeaderHeight))
        label.textAlignment = .center
        
        view.addSubview(label)
        let sectionInfo = fetchTheEvents.sections[section]
        label.text = sectionInfo.name
        label.font = UIFont(name: "Helvetica Neue", size: 15.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.eventsTableView.sectionHeaderHeight
    }
    
    
}
