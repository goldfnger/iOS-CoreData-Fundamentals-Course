//
//  ShoutOutTests.swift
//  ShoutOutTests

import XCTest
import UIKit
import CoreData

@testable import ShoutOut

class ShoutOutTests: XCTestCase {
	
	var systemUnderTest: ShoutOutDraftsViewController!
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		let storyboard = UIStoryboard(name: "Main",
		                              bundle: Bundle.main)
		let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        systemUnderTest = (navigationController.viewControllers[0] as! ShoutOutDraftsViewController)
		
		UIApplication.shared.keyWindow!.rootViewController = systemUnderTest
		
		// Using the preloadView() extension method
		navigationController.preloadView()
		systemUnderTest.preloadView()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
  func testManagedObjectContext() {
    let managedObjectContext = createMainContext()
    self.systemUnderTest.managedObjectContext = managedObjectContext
    
    
    XCTAssertNotNil(self.systemUnderTest.managedObjectContext, "managedObjectContext should not be nil")
  }
}

func createMainContextInMemory() -> NSManagedObjectContext {
  
  // initialize NSManagedObjectModel
  let modelURL = Bundle.main.url(forResource: Constants.CoreData.shoutOutEntityName, withExtension: Constants.CoreData.momdExtension)
  guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
    fatalError("model not found")
  }
  
  // configure NSPersistentStoreCoordinator with NSPersistentStore
  let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
  
  try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
  
  // create and return NSManagedObjectContext
  let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  context.persistentStoreCoordinator = psc
  
  return context
}

extension UIViewController {
	func preloadView() {
		_ = view
	}
}
