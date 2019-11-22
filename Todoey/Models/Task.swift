
//
//  Task.swift
//  Todoey
//
//  Created by Anes Abismail on 11/22/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}
