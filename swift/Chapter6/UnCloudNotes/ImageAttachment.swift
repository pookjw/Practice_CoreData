//
//  ImageAttachment.swift
//  UnCloudNotes
//
//  Created by Jinwoo Kim on 6/29/21.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class ImageAttachment: Attachment {
  @NSManaged var image: UIImage?
  @NSManaged var width: Float
  @NSManaged var height: Float
  @NSManaged var caption: String
}
