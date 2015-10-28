//
//  Hospital+CoreDataProperties.swift
//  SOSHospital
//
//  Created by Swift-Noturno on 27/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hospital {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var descriptionHospital: String?
    @NSManaged var latitude: NSDecimalNumber?
    @NSManaged var longitude: NSDecimalNumber?

}
