//
//  ShoutOutDetailsViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutDetailsViewController: UIViewController,
                                     ManagedObjectContextDependentType {
  
  var shoutOut: ShoutOut!
  var managedObjectContext: NSManagedObjectContext!
  
  @IBOutlet weak var shoutCategoryLabel: UILabel!
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var fromLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addNSManagedObjectContextDidSaveObserver()
    setUIValues()
  }
  
  func addNSManagedObjectContextDidSaveObserver() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                           object: nil,
                                           queue: nil)
    { (notification: Notification) in
      if let updatedShoutOuts = notification.userInfo?[NSUpdatedObjectsKey] as? Set<ShoutOut> {
        self.shoutOut = updatedShoutOuts.first
        self.setUIValues()
      }
    }
  }
  
  @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Delete ShoutOut",
                                            message: "Are you sure you want to delete this ShoutOut?",
                                            preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
      (_) -> Void in
      
      self.managedObjectContext.delete(self.shoutOut)
      
      do {
        try self.managedObjectContext.save()
      } catch {
        self.managedObjectContext.rollback()
        print("Something went wrong: \(error)")
      }
      
      let _ = self.navigationController?.popViewController(animated: true)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - Remove Observer
  deinit {
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name.NSManagedObjectContextDidSave,
                                              object: nil)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navigationController = segue.destination as! UINavigationController
    let destinationVC = navigationController.viewControllers[0] as! ShoutOutEditorViewController
    destinationVC.managedObjectContext = self.managedObjectContext
    destinationVC.shoutOut = self.shoutOut
  }
  
  //MARK: - configure UI
  func setUIValues() {
    self.shoutCategoryLabel.text = self.shoutOut.shoutCategory
    self.messageTextView.text = self.shoutOut.message
    self.fromLabel.text = self.shoutOut.from
  }
}
