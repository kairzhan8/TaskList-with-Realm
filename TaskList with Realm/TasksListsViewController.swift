//
//  TasksListsViewController.swift
//  TaskList with Realm
//
//  Created by Kairzhan Kural on 9/15/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListsViewController: UITableViewController {
    
    var tasksLists: Results<TasksList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksLists = realm.objects(TasksList.self)
        
//        let shoppingList = TasksList()
//        shoppingList.name = "Shopping List"
//
//        let todaysTasks = TasksList(value: ["Today's tasks"])
//
//        let milk = Task(value: ["name":"Milk", "note":"10L"])
//        let bread = Task(value: ["Bread"])
//        let butter = Task(value: ["name":"Butter", "isCompleted": true])
//
//        let read = Task(value: ["name":"Read a book", "note":"25 pages"])
//        let abs = Task(value: ["name":"Train abs", "isCompleted": true])
//        let water = Task(value: ["name":"Drink water", "note":"2L"])
//        let lesson = Task(value: ["name":"Watch lesson", "note":"2 lesssons", "isCompleted": true])
//
//        shoppingList.tasks.insert(contentsOf: [milk, bread, butter], at: 0)
//        todaysTasks.tasks.insert(contentsOf: [read, abs, water, lesson], at: 0)
//
//        DispatchQueue.main.async {
//            StorageManager.saveTasksList([shoppingList, todaysTasks])
//        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksLists", for: indexPath)

        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel!.text = String(tasksList.tasks.count)

        return cell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksListViewController
            tasksVC.currentTasksList = tasksList
        }
    }
    

}
