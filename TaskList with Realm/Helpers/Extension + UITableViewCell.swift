//
//  Extension + UITableViewCell.swift
//  TaskList with Realm
//
//  Created by Kairzhan Kural on 9/16/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func configure(_ tasksList: TasksList) {
        
        let currentTasks = tasksList.tasks.filter("isCompleted = false")
        let completedTasks = tasksList.tasks.filter("isCompleted = true")
        
        textLabel?.text = tasksList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel!.text = "\(currentTasks.count)"
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✅"
        } else {
            detailTextLabel!.text = "0"
        }
    }
}
