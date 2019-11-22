//
//  Category.swift
//  Todoey
//
//  Created by Anes Abismail on 11/22/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let tasks = List<Task>()
}
