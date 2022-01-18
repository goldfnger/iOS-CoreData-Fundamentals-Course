//
//  ShoutOutEditorViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutEditorViewController: UIViewController,
                                    ManagedObjectContextDependentType,
                                    UIPickerViewDataSource,
                                    UIPickerViewDelegate {
  
  var shoutOut: ShoutOut!
  var managedObjectContext: NSManagedObjectContext!
  
	@IBOutlet weak var toEmployeePicker: UIPickerView!
	@IBOutlet weak var shoutCategoryPicker: UIPickerView!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var fromTextField: UITextField!
  
  let shoutCategories = ["Great Job!",
                         "Awesome Work!",
                         "Well Done!",
                         "Amazing Effort!"
  ]
  
  var employee: [Employee]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
    fetchEmployees()
    setupUI()
    setUIValues()
	}
  
  func fetchEmployees() {
    let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
    
    let primarySortDescriptor = NSSortDescriptor(key: #keyPath(Employee.lastName), ascending: true)
    let secondarySortDescriptor = NSSortDescriptor(key: #keyPath(Employee.firstName), ascending: true)
    
    employeeFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
    
    
    do {
      self.employee = try self.managedObjectContext.fetch(employeeFetchRequest)
    } catch {
      self.employee = []
      print("something went wrong: \(error)")
    }
    
  }

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
    self.managedObjectContext.rollback()
    
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    let selectedEmployeeIndex = self.toEmployeePicker.selectedRow(inComponent: 0)
    let selectedEmployee = self.employee[selectedEmployeeIndex]
    self.shoutOut.toEmployee = selectedEmployee
    
    let selectedShoutCategoryIndex = self.shoutCategoryPicker.selectedRow(inComponent: 0)
    let selectedShoutCategory = self.shoutCategories[selectedShoutCategoryIndex]
    self.shoutOut.shoutCategory = selectedShoutCategory
    
    self.shoutOut.message = self.messageTextView.text
    self.shoutOut.from = self.fromTextField.text ?? "Anonymous"
    
    do {
      try self.managedObjectContext.save()
      self.dismiss(animated: true, completion: nil)
    } catch {
      let alert = UIAlertController(title: "trouble saving",
                                    message: "something went wrong when tyring to save the data",
                                    preferredStyle: .alert)
      let okAction = UIAlertAction(title: "ok",
                                   style: .default) { [self] action in
        self.managedObjectContext.rollback()
        self.shoutOut = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: self.managedObjectContext) as! ShoutOut
      }
      
      alert.addAction(okAction)
      
      self.present(alert, animated: true, completion: nil)
    }

	}
  
  //MARK: - UIPickerView
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerView.tag == 0 ? self.employee.count : self.shoutCategories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 0 {
      let employee = self.employee[row]
      print("1 \(employee)")
      
      return "\(employee.firstName!) \(employee.lastName!)"
    } else {
      return shoutCategories[row]
    }
  }
}
//MARK: - Configure UI
extension ShoutOutEditorViewController {
  func setupUI() {
    self.toEmployeePicker.delegate = self
    self.toEmployeePicker.dataSource = self
    self.toEmployeePicker.tag = 0
    
    self.shoutCategoryPicker.delegate = self
    self.shoutCategoryPicker.dataSource = self
    self.shoutCategoryPicker.tag = 1
    
    // if shoutOut exist - use it. if nil - insertNewObject.
    self.shoutOut = self.shoutOut ?? NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: self.managedObjectContext) as! ShoutOut
    
    messageTextView.layer.borderWidth = CGFloat(0.5)
    messageTextView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
    messageTextView.layer.cornerRadius = 5
    messageTextView.clipsToBounds = true
  }
  
  func setUIValues() {
    let selectedEmployeeRow = self.employee.firstIndex(of: self.shoutOut.toEmployee) ?? 0
    self.toEmployeePicker.selectRow(selectedEmployeeRow, inComponent: 0, animated: true)
    
    let selectedShoutCategoryRow = self.shoutCategories.firstIndex(of: self.shoutOut.shoutCategory) ?? 0
    self.shoutCategoryPicker.selectRow(selectedShoutCategoryRow, inComponent: 0, animated: true)
    
    self.messageTextView.text = self.shoutOut.message
    self.fromTextField.text = self.shoutOut.from
  }
}
