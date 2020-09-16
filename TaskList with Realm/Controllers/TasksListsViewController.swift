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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = self.tasksLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            
            self.alertForAddAndUpdateList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
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
    
    private func alertForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editList(listName, newListName: newList)
                if complition != nil {
                    complition!()
                }
            } else {
                let tasksList = TasksList()
                tasksList.name = newList
                
                StorageManager.saveTasksList(tasksList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
                   alertTextField = textField
                   alertTextField.placeholder = "List name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
