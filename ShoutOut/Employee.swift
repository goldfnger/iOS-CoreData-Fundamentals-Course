//
//  Employee.swift
//  ShoutOut
//
//  Created by Aleksandr Kornjushko on 13.01.2022.
//  Copyright © 2022 pluralsight. All rights reserved.
//

import Foundation
import CoreData

class Employee: NSManagedObject {
  @NSManaged var firstName: String?
  @NSManaged var lastName: String?
  @NSManaged var department: String
  
  @NSManaged var shoutOuts: NSSet?
  
  static var entityName: String { return Constants.CoreData.employeeEntityName }

}
