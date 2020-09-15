//
//  StorageManager.swift
//  TaskList with Realm
//
//  Created by Kairzhan Kural on 9/15/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTasksList(_ tasksLists: [TasksList]) {
        try! realm.write {
            realm.add(tasksLists)
        }
    }

}
