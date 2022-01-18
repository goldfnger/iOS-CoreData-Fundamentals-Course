//
//  Constants.swift
//  ShoutOut
//
//  Created by Aleksandr Kornjushko on 11.01.2022.
//

import Foundation

struct Constants {
  struct CoreData {
    static let shoutOutEntityName = "ShoutOut"
    static let employeeEntityName = "Employee"
    static let momdExtension = "momd"
    static let shoutOutSqlite = "ShoutOut.sqlite"
  }
  
  struct SegueIdentifiers {
    static let shoutOutDetails = "shoutOutDetails"
    static let addShoutOut = "addShoutOut"
    static let editShoutOut = "editShoutOut"
    
  }
  
  struct ViewControllers {
    static let rootViewController = "RootViewController"
  }
}
