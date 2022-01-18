//
//  DataService.swift
//  ShoutOut
//
//  Created by Aleksandr Kornjushko on 13.01.2022.
//

import Foundation
import CoreData

struct DataService: ManagedObjectContextDependentType {
  var managedObjectContext: NSManagedObjectContext!
  
  func seedEmployees() {
    
    let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
    
    do {
      let employees = try self.managedObjectContext.fetch(employeeFetchRequest)
      let employeesAlreadySeeded = try employees.count > 0
      
      if(employeesAlreadySeeded == false) {
        let employee1 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee1.firstName = "Aleksandr"
        employee1.lastName = "Kornjushko"
        employee1.department = "Development"
        let employee2 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee2.firstName = "Boba"
        employee2.lastName = "Fett"
        employee2.department = "Bounty Hunters"
        
        let employee3 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee3.firstName = "Din"
        employee3.lastName = "Djarin"
        employee3.department = "Mandalorians"
        
        let employee4 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee4.firstName = "Yoda"
        employee4.lastName = "Junior"
        employee4.department = "Jedi Order"
        
        let employee5 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee5.firstName = "Tony"
        employee5.lastName = "Soprano"
        employee5.department = "American-Italy mafia"
        
        let employee6 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName,
                                                            into: self.managedObjectContext) as! Employee
        employee6.firstName = "Leonard"
        employee6.lastName = "Hofstadter"
        employee6.department = "TBBT member"
        
        do {
          try self.managedObjectContext.save()
        } catch {
          print("something went wrong: \(error)")
          // roll back set managedObjectContext to original pre-inserted new object state
          self.managedObjectContext.rollback()
        }
      }
    } catch {
      
    }
   
  }
  
}
