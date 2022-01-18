//
//  SaveAccessDelete.swift
//  ShoutOutTests
//
//  Created by Aleksandr Kornjushko on 13.01.2022.
//  Copyright © 2022 pluralsight. All rights reserved.
//

import XCTest
import CoreData

@testable import ShoutOut

class SaveAccessDelete: XCTestCase {
  
  var managedObjectContext: NSManagedObjectContext!
  var dataService: DataService!

    override func setUpWithError() throws {
      super.setUp()
      // 1. instance managedObjectContext
      self.managedObjectContext = createMainContextInMemory()
      // 2. instance DataService
      self.dataService = DataService(managedObjectContext: managedObjectContext)
      // 3. stick employees in persistent store
      self.dataService.seedEmployees()
    }

    override func tearDownWithError() throws {
      super.tearDown()
    }
  
  func testFetchAllEmployees() {
    // 1. initialise NSFetchRequest
    let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
    
    // 2. perform fetch
    do {
      let employees = try managedObjectContext.fetch(employeeFetchRequest)
      print(employees)
    } catch {
      print("something went wrong: \(error)")
    }
  }

  func testFilterShoutOuts() {
    seedShoutOutsForTesting(managedObjectContext: managedObjectContext)
    
    let shoutOutsFetchRequest = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
    // %K - key path. %@ - object value string/number/date.
    let shoutCategoryEqualityPredicate = NSPredicate(format: "%K == %@", #keyPath(ShoutOut.shoutCategory), "Great Job!")
    shoutOutsFetchRequest.predicate = shoutCategoryEqualityPredicate
    
    do {
      let filteredShoutOuts = try managedObjectContext.fetch(shoutOutsFetchRequest)
      print("----------First Result Set----------")
      printShoutOuts(shoutOuts: filteredShoutOuts)
    } catch {
      print("Something went wrong fetching ShoutOuts: \(error)")
    }
    
    let shoutCategoryINPredicate = NSPredicate(format: "%K IN %@", #keyPath(ShoutOut.shoutCategory), "Great Job!, Well Done!")
    shoutOutsFetchRequest.predicate = shoutCategoryINPredicate
    
    do {
      let filteredShoutOuts = try managedObjectContext.fetch(shoutOutsFetchRequest)
      print("----------Second Result Set----------")
      printShoutOuts(shoutOuts: filteredShoutOuts)
    } catch {
      print("Something went wrong fetching ShoutOuts: \(error)")
    }
    
    let beginsWithPredicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(ShoutOut.toEmployee.lastName), "Rodrig")
    shoutOutsFetchRequest.predicate = beginsWithPredicate
    
    do {
      let filteredShoutOuts = try managedObjectContext.fetch(shoutOutsFetchRequest)
      print("----------Third Result Set----------")
      printShoutOuts(shoutOuts: filteredShoutOuts)
    } catch {
      print("Something went wrong fetching ShoutOuts: \(error)")
    }
  }
  
  func seedShoutOutsForTesting(managedObjectContext: NSManagedObjectContext) {
    let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
    
    do {
      let employees = try managedObjectContext.fetch(employeeFetchRequest)
      
      let shoutOut1 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut1.shoutCategory = "Great Job!"
      shoutOut1.message = "Hey, great job on that project!"
      shoutOut1.toEmployee = employees[0]
      
      let shoutOut2 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut2.shoutCategory = "Great Job!"
      shoutOut2.message = "Couldn't have presented better at the conference last week!"
      shoutOut2.toEmployee = employees[1]
      
      let shoutOut3 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut3.shoutCategory = "Awesome Work!"
      shoutOut3.message = "You always do awesome work!"
      shoutOut3.toEmployee = employees[2]
      
      let shoutOut4 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut4.shoutCategory = "Awesome Work!"
      shoutOut4.message = "You've done an amazing job this year!"
      shoutOut4.toEmployee = employees[3]
      
      let shoutOut5 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut5.shoutCategory = "Well Done!"
      shoutOut5.message = "I'm impressed with the results of your prototoype!"
      shoutOut5.toEmployee = employees[4]
      
      let shoutOut6 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                          into: managedObjectContext) as! ShoutOut
      shoutOut6.shoutCategory = "Well Done!"
      shoutOut6.message = "Keep up the good work!"
      shoutOut6.toEmployee = employees[5]
      
      do {
        try managedObjectContext.save()
      } catch {
        print("Something went wrong with saving ShoutOuts: \(error)")
        managedObjectContext.rollback()
      }
    } catch {
      print("Something went wrong fetching employees: \(error)")
    }
  }
  
  func testSortShoutOuts() {
    seedShoutOutsForTesting(managedObjectContext: managedObjectContext)
    
    let shoutOutsFetchRequest = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
    
    do {
      let shoutOuts = try managedObjectContext.fetch(shoutOutsFetchRequest)
      print("----------Unsorted ShoutOuts----------")
      printShoutOuts(shoutOuts: shoutOuts)
    } catch _ {}
    
    let shoutCategorySortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.shoutCategory), ascending: true)
    let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.lastName), ascending: true)
    let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.firstName), ascending: true)
    
    shoutOutsFetchRequest.sortDescriptors = [shoutCategorySortDescriptor, lastNameSortDescriptor, firstNameSortDescriptor]
    
    do {
      let shoutOuts = try managedObjectContext.fetch(shoutOutsFetchRequest)
      print("----------Sorted ShoutOuts----------")
      printShoutOuts(shoutOuts: shoutOuts)
    } catch _ {}
  }
  
  func printShoutOuts(shoutOuts: [ShoutOut]) {
    for shoutOut in shoutOuts {
      print("\n----------ShoutOut----------")
      print("Shout Category: \(shoutOut.shoutCategory)")
            print("Message: \(shoutOut.message ?? "")")
      print("To: \(shoutOut.toEmployee.firstName) \(shoutOut.toEmployee.lastName)")
    }
  }
}
