//
//  EmployeePicture.swift
//  EmployeeDirectory
//
//  Created by Jinwoo Kim on 6/30/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation
import CoreData

public class EmployeePicture: NSManagedObject {
}

extension EmployeePicture {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
    return NSFetchRequest<EmployeePicture>(entityName: "EmployeePicture")
  }
  
  @NSManaged public var picture: Data?
  @NSManaged public var employye: Employee?
}
