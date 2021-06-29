//
//  AttachmentToImageAttachmentMigrationPolicyV3ToV4.swift
//  UnCloudNotes
//
//  Created by Jinwoo Kim on 6/29/21.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

let errorDomain = "Migration"

class AttachmentToImageAttachmentMigrationPolicyV3ToV4: NSEntityMigrationPolicy {
  override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                           in mapping: NSEntityMapping,
                                           manager: NSMigrationManager) throws {
    
    // 1
    let description = NSEntityDescription.entity(forEntityName: "ImageAttachment",
                                                 in: manager.destinationContext)
    
    let newAttachment = ImageAttachment(entity: description!,
                                        insertInto: manager.destinationContext)
    
    // 2
    func traversePropertyMappings(block: (NSPropertyMapping, String) -> Void) throws {
      
      if let attributesMappings = mapping.attributeMappings {
        for propertyMappings in attributesMappings {
          if let destinationName = propertyMappings.name {
            block(propertyMappings, destinationName)
          } else {
            // 3
            let message = "Attribute destination not configured properly"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
          }
        }
      } else {
        let message = "No Attribute Mappings found!"
        let userInfo = [NSLocalizedFailureReasonErrorKey: message]
        throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
      }
    }
    
    // 4
    try traversePropertyMappings { propertyMapping, destinationName in
    
      if let valueExpression = propertyMapping.valueExpression {
        let context: NSMutableDictionary = ["source": sInstance]
        guard let destinationValue = valueExpression.expressionValue(with: sInstance, context: context) else {
          return
        }
        
        newAttachment.setValue(destinationValue, forKey: destinationName)
      }
    }
    
    // 5
    if let image = sInstance.value(forKey: "image") as? UIImage {
      newAttachment.setValue(image.size.width, forKey: "width")
      newAttachment.setValue(image.size.height, forKey: "height")
    }
    
    // 6
    let body = sInstance.value(forKeyPath: "note.body") as? NSString ?? ""
    newAttachment.setValue(body.substring(to: 80), forKey: "caption")
    
    // 7
    manager.associate(sourceInstance: sInstance,
                      withDestinationInstance: newAttachment,
                      for: mapping)
  }
}
