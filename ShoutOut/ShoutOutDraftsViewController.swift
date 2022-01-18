//
//  ViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutDraftsViewController: UIViewController,
                  ManagedObjectContextDependentType{

	@IBOutlet weak var tableView: UITableView!
  
  var managedObjectContext: NSManagedObjectContext!
  var fetchResultsController: NSFetchedResultsController<ShoutOut>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
    configureFetchedResultsController()
    
    do {
      try self.fetchResultsController.performFetch()
    } catch {
      let alertController = UIAlertController(title: "Loading SHoutOut Failed",
                                              message: "There was a problem loading the list of ShoutOut drafts. Please try again.",
                                              preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      
      alertController.addAction(okAction)
      
      self.present(alertController, animated: true, completion: nil)
    }
	}
  
  // configuration of NSFetchRequest to work with core data
  func configureFetchedResultsController() {
    let shoutOutFetchRequest = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
    let departmentSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.department), ascending: true)
    let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.lastName), ascending: true)
    let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.firstName), ascending: true)
    
    shoutOutFetchRequest.sortDescriptors = [departmentSortDescriptor,lastNameSortDescriptor, firstNameSortDescriptor]
    
    self.fetchResultsController = NSFetchedResultsController<ShoutOut>(fetchRequest: shoutOutFetchRequest,
                                                                       managedObjectContext: self.managedObjectContext,
                                                                       sectionNameKeyPath: #keyPath(ShoutOut.toEmployee.department),
                                                                       cacheName: nil)
    self.fetchResultsController.delegate = self
  }
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case Constants.SegueIdentifiers.shoutOutDetails:
      let destinationVC = segue.destination as! ShoutOutDetailsViewController
      destinationVC.managedObjectContext = self.managedObjectContext
      
      let selectedIndexPath = self.tableView.indexPathForSelectedRow!
      let selectedShoutOut = self.fetchResultsController.object(at: selectedIndexPath)
      
      destinationVC.shoutOut = selectedShoutOut
      
    case Constants.SegueIdentifiers.addShoutOut:
      let navigationController = segue.destination as! UINavigationController
      let destinationVC = navigationController.viewControllers[0] as! ShoutOutEditorViewController
      destinationVC.managedObjectContext = self.managedObjectContext
      
    default:
      break
    }
	}
}

// MARK: TableView Data Source methods
extension ShoutOutDraftsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if let sections = self.fetchResultsController.sections {
      return sections.count
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = self.fetchResultsController.sections {
      let currentSection = sections[section]
      return currentSection.name
    }
    
    return nil
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // getting using core data fetch request NSFetchedResultsController
    if let sections = self.fetchResultsController.sections {
      return sections[section].numberOfObjects
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
    
    let shoutOut = self.fetchResultsController.object(at: indexPath)
    
    cell.textLabel?.text = "\(shoutOut.toEmployee.firstName) \(shoutOut.toEmployee.lastName)"
    cell.detailTextLabel?.text = shoutOut.shoutCategory
    
    print(shoutOut.toEmployee.department)
    return cell
  }
}

// MARK: TableView Delegate methods
extension ShoutOutDraftsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: NSFetchedResultsController Delegate methods
extension ShoutOutDraftsViewController: NSFetchedResultsControllerDelegate {
  
  // WillChange and DidChange need to make any changes looks smoothly animated
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      if let insertedIndexPath = newIndexPath {
        self.tableView.insertRows(at: [insertedIndexPath], with: .fade)
      }
      
    case .delete:
      if let deleteIndexPath = indexPath {
        self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
      }
      
    case .update:
      if let updateIndexPath = indexPath {
        let cell = self.tableView.cellForRow(at: updateIndexPath)
        let updateShoutOut = self.fetchResultsController.object(at: updateIndexPath)
        
        cell?.textLabel?.text = "\(updateShoutOut.toEmployee.firstName!) \(updateShoutOut.toEmployee.lastName!)"
        cell?.detailTextLabel?.text = updateShoutOut.shoutCategory
      }
      
    case .move:
      if let deleteIndexPath = indexPath {
        self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
      }
      
      if let insertedIndexPath = newIndexPath {
        self.tableView.insertRows(at: [insertedIndexPath], with: .fade)
      }

    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
    return sectionName
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
    
    switch type {
    case .insert:
      self.tableView.insertSections(sectionIndexSet, with: .fade)
      
    case .delete:
      self.tableView.deleteSections(sectionIndexSet, with: .fade)

      
    default:
      break;
    }
  }
}
