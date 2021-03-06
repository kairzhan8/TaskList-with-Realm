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
    
    static func editList(_ tasksList: TasksList, newListName: String) {
        try! realm.write {
            tasksList.name = newListName
        }
    }
    
    static func makeAllDone(_ tasksList: TasksList) {
        try! realm.write {
            tasksList.tasks.setValue(true, forKey: "isCompleted")
        }
    }
    
    // MARK: - Tasks methods
    
    static func saveTask(_ tasksList: TasksList, _ task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func editTask(_ task: Task, newTaskName: String, newNoteName: String) {
        try! realm.write {
            task.name = newTaskName
            task.note = newNoteName
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isCompleted.toggle()
        }
    }

}
