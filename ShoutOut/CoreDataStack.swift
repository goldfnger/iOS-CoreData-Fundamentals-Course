//
//  CoreDataStack.swift
//  ShoutOut
//
//  Created by Aleksandr Kornjushko on 11.01.2022.
//

import Foundation
import CoreData

func createMainContext(completion: @escaping (NSPersistentContainer) -> Void) {
  
  let container = NSPersistentContainer(name: Constants.CoreData.shoutOutEntityName)
  
  // For brand new project this 3 lines is not required, they need as part of refactoring to use previously created persistent store
  let storeURL = URL.documentsURL.appendingPathComponent(Constants.CoreData.shoutOutSqlite)
  let storeDescription = NSPersistentStoreDescription(url: storeURL)
  container.persistentStoreDescriptions = [storeDescription]
  
  // happens asynchronously
  container.loadPersistentStores { persistentStoreDescription, error in
    
    guard error == nil else { fatalError("Failed to load store: \(error)")}
    
    DispatchQueue.main.async {
      completion(container)
    }
  }
  
  /* before refactor
  // initialize NSManagedObjectModel
  let modelURL = Bundle.main.url(forResource: Constants.CoreData.shoutOutEntityName, withExtension: Constants.CoreData.momdExtension)
  guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
    fatalError("model not found")
  }
  
  // configure NSPersistentStoreCoordinator with NSPersistentStore
  let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
  let storeURL = URL.documentsURL.appendingPathComponent(Constants.CoreData.shoutOutSqlite)
  
  // ---How to perform Lightweight model migration when application is published in app store---
  // Enable migration. 0) Preparation. First need to create new model version by selecting current model > Editor > Add Model Version,
  // if adding new Attribute to Entity - need to provide Default value in Data Model Inspector,
  // if updating existing Attribute - in Data Model Inspector under Versioning section need to set old attribute value in "Renaming ID".
  // For example sentDate was changed to sentOn, so in "Renaming ID" need to put sentDate.
  // After all changes were done - finish step Enable migration. 3)
  
  // Enable migration. 1) to enable migration for core data model need to setup options:
  let pscOptions = [
    NSMigratePersistentStoresAutomaticallyOption: true,
    NSInferMappingModelAutomaticallyOption: true
  ]
  
//   Enable migration. 2) configure options with pscOptions
    try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: pscOptions)
  
  //   Enable migration. 3) add/update/remove all changes which were done in model to manually generated core data objects: ShoutOut.swift / Employee.swift
  
  // create and return NSManagedObjectContext
  let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  context.persistentStoreCoordinator = psc
  
  return context
   */
}
//MARK: - Extensions
extension URL {
  static var documentsURL: URL {
    return try! FileManager
      .default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  }
}

//MARK: - Protocols

protocol ManagedObjectContextDependentType {
  var managedObjectContext: NSManagedObjectContext! { get set }
}
