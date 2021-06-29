//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by Jinwoo Kim on 6/29/21.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class Attachment: NSManagedObject {
  @NSManaged var dateCreated: Date
  @NSManaged var note: Note?
}
