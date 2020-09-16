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
    
    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList.name
        filteringTasks()
    }
    
    @IBAction func addNewTask(_ sender: UIButton) {
        alertForAddAndUpdateTask()
    }
    @IBAction func editCurrentTask(_ sender: UIButton) {
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current Tasks" : "Completed Tasks"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksList", for: indexPath)

        var task: Task!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isCompleted = false")
        completedTasks = currentTasksList.tasks.filter("isCompleted = true")
        tableView.reloadData()
    }

}

extension TasksListViewController {
    
    private func alertForAddAndUpdateTask() {
        
        let alert = UIAlertController(title: "New Task", message: "Insert a new value", preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newTask = taskTextField.text, !newTask.isEmpty else { return }
            
            let task = Task()
            task.name = newTask
            
            if let note = noteTextField.text, !note.isEmpty {
                task.note = note
            }
            
            StorageManager.saveTask(self.currentTasksList, task)
            self.filteringTasks()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            taskTextField = textField
            taskTextField.placeholder = "New Task"
        }
        alert.addTextField { (textField) in
            noteTextField = textField
            noteTextField.placeholder = "Note"
        }
        
        present(alert, animated: true)
        
    }
}
