//
//  ColorAttributeTransformer.swift
//  BowTies
//
//  Created by Jinwoo Kim on 6/21/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit

class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
  // 1
  override static var allowedTopLevelClasses: [AnyClass] {
    return [UIColor.self]
  }
  
  // 2
  static func register() {
    let className = String(describing: ColorAttributeTransformer.self)
    let name = NSValueTransformerName(className)
    
    let transformer = ColorAttributeTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}
