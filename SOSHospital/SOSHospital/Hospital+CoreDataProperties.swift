//
//  Hospital+CoreDataProperties.swift
//  SOSHospital
//
//  Created by William kwong huang on 28/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hospital {

    @NSManaged var id: Int64
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var state: String?

}
