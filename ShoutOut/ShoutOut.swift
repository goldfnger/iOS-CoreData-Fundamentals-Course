//
//  ShoutOut.swift
//  ShoutOut
//
//  Created by Aleksandr Kornjushko on 13.01.2022.
//

import Foundation
import CoreData

class ShoutOut: NSManagedObject {
  @NSManaged var from: String?
  @NSManaged var message: String?
  @NSManaged var sentOn: Date?
  @NSManaged var shoutCategory: String
  
  @NSManaged var toEmployee: Employee
  
  static var entityName: String { return Constants.CoreData.shoutOutEntityName }
}
