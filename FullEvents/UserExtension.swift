//
//  UserExtension.swift
//  FullEvents
//
//  Created by user on 19/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import CoreData
import AlecrimCoreData

extension NSManagedObjectContext {
    
    // users will be having all the attributes corresponding to that entity
    
    var users: Table<User> { return Table<User>(context : self) }
    var streams: Table<UserStreams> { return Table<UserStreams>(context : self) }
    var events: Table<Event> { return Table<Event>(context : self)}
    
}
