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
        
    }
    
    @IBAction func addNewList(_ sender: UIButton) {
        alertForAddAndUpdateList()
    }
    @IBAction func editCurrentList(_ sender: UIButton) {
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

extension TasksListsViewController {
    private func alertForAddAndUpdateList() {
        let alert = UIAlertController(title: "New List", message: "Write a new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            let tasksList = TasksList()
            tasksList.name = newList
            
            StorageManager.saveTasksList(tasksList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
                   alertTextField = textField
                   alertTextField.placeholder = "List name"
               }
        present(alert, animated: true)
    }
}
