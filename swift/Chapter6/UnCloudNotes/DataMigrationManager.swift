//
//  DataMigrationManager.swift
//  UnCloudNotes
//
//  Created by Jinwoo Kim on 6/30/21.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class DataMigrationManager {
  let enableMigrations: Bool
  let modelName: String
  let storeName: String = "UnCloudNotesDataModel"
  
  private var applicationSupportURL: URL {
    let path = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true).first
    return URL(fileURLWithPath: path!)
  }
  
  private lazy var storeURL: URL = {
    let storeFileName = "\(self.storeName).sqlite"
    return URL(fileURLWithPath: storeFileName, relativeTo: self.applicationSupportURL)
  }()
  
  /// 현재 Store의 모델
  private var storeModel: NSManagedObjectModel? {
    NSManagedObjectModel.modelVersionFor(modelNamed: modelName)
    // 전체 모델 중에 현재 Store와 동일한 모델을 가져온다.
      .first { self.store(at: storeURL, isCompatibleWithModel: $0) }
  }
  
  /// 최신 버전의 Model
  private lazy var currentModel: NSManagedObjectModel = .model(named: self.modelName)
  
  var stack: CoreDataStack {
    guard enableMigrations,
          // 모델 업그레이드 가능성 체크
          !store(at: storeURL, isCompatibleWithModel: currentModel)
    else { return CoreDataStack(modelName: modelName) }
    
    performMigration()
    return CoreDataStack(modelName: modelName)
  }
  
  init(modelNamed: String, enableMigrations: Bool = false) {
    self.modelName = modelNamed
    self.enableMigrations = enableMigrations
  }
  
  func performMigration() {
    if !currentModel.isVersion4 {
      fatalError("Can only handle migrations to version 4!")
    }
    
    //
    
    if let storeModel = self.storeModel {
      if storeModel.isVersion1 {
        let destinationModel = NSManagedObjectModel.version2
        
        migrateStoreAt(URL: storeURL,
                       fromModel: storeModel,
                       toModel: destinationModel)
        
        performMigration()
      } else if storeModel.isVersion2 {
        let desinationModel = NSManagedObjectModel.version3
        let mappingModel = NSMappingModel(from: nil,
                                          forSourceModel: storeModel,
                                          destinationModel: desinationModel)
        
        migrateStoreAt(URL: storeURL,
                       fromModel: storeModel,
                       toModel: desinationModel,
                       mappingModel: mappingModel)
        
        performMigration()
      } else if storeModel.isVersion3 {
        let desinationModel = NSManagedObjectModel.version4
        let mappingModel = NSMappingModel(from: nil,
                                          forSourceModel: storeModel,
                                          destinationModel: desinationModel)
        
        migrateStoreAt(URL: storeURL,
                       fromModel: storeModel,
                       toModel: desinationModel,
                       mappingModel: mappingModel)
        
        performMigration()
      }
    }
  }
  
  private func migrateStoreAt(URL storeURL: URL,
                              fromModel from: NSManagedObjectModel,
                              toModel to: NSManagedObjectModel,
                              mappingModel: NSMappingModel? = nil) {
    // 1
    let migrationManager = NSMigrationManager(sourceModel: from, destinationModel: to)
    
    // 2
    var migrationMappingModel: NSMappingModel
    
    if let mappingModel = mappingModel {
      migrationMappingModel = mappingModel
    } else {
      migrationMappingModel = try! NSMappingModel
        .inferredMappingModel(forSourceModel: from, destinationModel: to)
    }
    
    // 3
    let targetURL = storeURL.deletingLastPathComponent()
    let destinationName = storeURL.lastPathComponent + "~1"
    let destinationURL = targetURL.appendingPathComponent(destinationName)
    
    print("From Model: \(from.entityVersionHashesByName)")
    print("To Model: \(to.entityVersionHashesByName)")
    print("Migrating store \(storeURL) to \(destinationURL)")
    print("Mapping model: \(String(describing: mappingModel))")
    
    // 4
    let success: Bool
    do {
      try migrationManager.migrateStore(from: storeURL,
                                        sourceType: NSSQLiteStoreType,
                                        options: nil,
                                        with: migrationMappingModel,
                                        toDestinationURL: destinationURL,
                                        destinationType: NSSQLiteStoreType,
                                        destinationOptions: nil)
      success = true
    } catch {
      success = false
      print("Migration failed: \(error)")
    }
    
    // 5
    if success {
      print("Migration Completed Successfully")
      
      let fileManager = FileManager.default
      do {
        try fileManager.removeItem(at: storeURL)
        try fileManager.moveItem(at: destinationURL, to: storeURL)
      } catch {
        print("Error migrating \(error)")
      }
    }
  }
  
  private func store(at storeURL: URL, isCompatibleWithModel model: NSManagedObjectModel) -> Bool {
    let storeMetadata = metadataForStoreAtURL(storeURL: storeURL)
    
    return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetadata)
  }
  
  private func metadataForStoreAtURL(storeURL: URL) -> [String: Any] {
    let metadata: [String: Any]
    do {
      metadata = try NSPersistentStoreCoordinator
        .metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
    } catch {
      metadata = [:]
      print("Error retriving metadata for store at URL: \(storeURL): \(error)")
    }
    
    return metadata
  }
}

extension NSManagedObjectModel {
  private class func modelURLs(in modelFolder: String) -> [URL] {
    Bundle.main.urls(forResourcesWithExtension: "mom", subdirectory: "\(modelFolder).momd") ?? []
  }
  
  class func modelVersionFor(modelNamed modelName: String) -> [NSManagedObjectModel] {
    modelURLs(in: modelName)
      .compactMap(NSManagedObjectModel.init)
  }
  
  class func uncloudNotesModel(named modelName: String) -> NSManagedObjectModel {
    let model = modelURLs(in: "UnCloudNotesDataModel")
      .first { $0.lastPathComponent == "\(modelName).mom" }
      .flatMap(NSManagedObjectModel.init)
    return model ?? NSManagedObjectModel()
  }
  
  //
  
  class var version1: NSManagedObjectModel {
    uncloudNotesModel(named: "UnCloudNotesDataModel")
  }
  
  class var version2: NSManagedObjectModel {
    uncloudNotesModel(named: "UnCloudNotesDataModel 2")
  }
  
  class var version3: NSManagedObjectModel {
    uncloudNotesModel(named: "UnCloudNotesDataModel 3")
  }
  
  class var version4: NSManagedObjectModel {
    uncloudNotesModel(named: "UnCloudNotesDataModel 4")
  }
  
  var isVersion1: Bool { self == Self.version1 }

  var isVersion2: Bool { self == Self.version2 }

  var isVersion3: Bool { self == Self.version3 }
  
  var isVersion4: Bool { self == Self.version4 }

  static func == (firstModel: NSManagedObjectModel, otherModel: NSManagedObjectModel) -> Bool {
    firstModel.entitiesByName == otherModel.entitiesByName
  }
  
  //
  
  class func model(named modelName: String,
                   in bundle: Bundle = .main)
  -> NSManagedObjectModel {
    
    bundle
      .url(forResource: modelName, withExtension: "momd")
      .flatMap(NSManagedObjectModel.init) ?? NSManagedObjectModel()
  }
}
