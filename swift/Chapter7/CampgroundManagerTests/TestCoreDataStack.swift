//
//  TestCoreDataStack.swift
//  CampgroundManagerTests
//
//  Created by Jinwoo Kim on 6/30/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import CampgroundManager
import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    
    let container = NSPersistentContainer(name: CoreDataStack.modelName,
                                          managedObjectModel: CoreDataStack.model)
    // /dev/null은 in-memory 공간 - 재실행하면 사라짐
    container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
    
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    self.storeContainer = container
  }
}
