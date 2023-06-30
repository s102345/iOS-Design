//
//  Car+CoreDataProperties.swift
//  MyCoreData
//
//  Created by Mac10 on 2023/5/17.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}

extension Car : Identifiable {

}
