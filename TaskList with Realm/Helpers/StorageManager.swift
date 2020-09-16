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
    
    // MARK: - TasksLists methods
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    // MARK: - Tasks methods
    
    static func saveTask(_ tasksList: TasksList, _ task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }

}
