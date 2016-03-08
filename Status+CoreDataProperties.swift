//
//  Status+CoreDataProperties.swift
//  TTTaskList
//
//  Created by Usuário Convidado on 08/03/16.
//  Copyright © 2016 Thiago Nogueira. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Status {

    @NSManaged var tipo: String?
    @NSManaged var tasks: NSSet?

}
