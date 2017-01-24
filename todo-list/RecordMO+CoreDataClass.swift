//
//  RecordMO+CoreDataClass.swift
//  todo-list
//
//  Created by Евгений Сафронов on 24.01.17.
//  Copyright © 2017 Evgeniy Safronov. All rights reserved.
//

import Foundation
import CoreData

@objc(RecordMO)
public class RecordMO: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: context)
        self.init(entity: entity!, insertInto: context)
    }
}
