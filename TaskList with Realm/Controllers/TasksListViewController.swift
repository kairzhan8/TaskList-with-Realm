//
//  TasksListViewController.swift
//  TaskList with Realm
//
//  Created by Kairzhan Kural on 9/15/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var currentTasksList: TasksList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList.name
        filteringTasks()
    }
    
    @IBAction func addNewTask(_ sender: UIButton) {
        alertForAddAndUpdateTask()
    }
    @IBAction func editCurrentTask(_ sender: UIButton) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current tasks" : "Completed tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksList", for: indexPath)

        var task: Task!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    
    // MARK - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.alertForAddAndUpdateTask(task)
            self.filteringTasks()
        }
        
        let title = task.isCompleted ? "Undone" : "Done"
        let doneAction = UIContextualAction(style: .normal, title: title) { (_, _, _) in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        editAction.backgroundColor = .orange
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, doneAction, editAction])
        
        return swipeActions
    }
    
    // MARK - Table view style
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

    
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isCompleted = false")
        completedTasks = currentTasksList.tasks.filter("isCompleted = true")
        tableView.reloadData()
    }

}

extension TasksListViewController {
    
    private func alertForAddAndUpdateTask(_ taskName: Task? = nil) {
        
        var title = "New task"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit task"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = taskTextField.text, !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newTaskName: newTask, newNoteName: newNote)
                } else {
                    StorageManager.editTask(taskName, newTaskName: newTask, newNoteName: "")
                }
                
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newTask
                
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                
                StorageManager.saveTask(self.currentTasksList, task)
                self.filteringTasks()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            taskTextField = textField
            taskTextField.placeholder = "New Task"
            
            if taskName != nil {
                taskTextField.text = taskName?.name
            }
            
        }
        alert.addTextField { (textField) in
            noteTextField = textField
            noteTextField.placeholder = "Note"
            
            if taskName != nil {
                noteTextField.text = taskName?.note
            }
        }
        
        present(alert, animated: true)
        
    }
}
