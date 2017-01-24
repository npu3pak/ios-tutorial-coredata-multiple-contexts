//
//  RecordMO+CoreDataProperties.swift
//  todo-list
//
//  Created by Евгений Сафронов on 24.01.17.
//  Copyright © 2017 Evgeniy Safronov. All rights reserved.
//

import Foundation
import CoreData


extension RecordMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordMO> {
        return NSFetchRequest<RecordMO>(entityName: "Record");
    }

    @NSManaged public var text: String?

}
