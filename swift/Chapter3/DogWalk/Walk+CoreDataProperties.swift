//
//  Walk+CoreDataProperties.swift
//  DogWalk
//
//  Created by Jinwoo Kim on 6/22/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation
import CoreData

extension Walk {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
    return NSFetchRequest<Walk>(entityName: "Walk")
  }
  
  @NSManaged public var date: Date?
  @NSManaged public var dog: Dog?
}

extension Walk: Identifiable {
  
}
