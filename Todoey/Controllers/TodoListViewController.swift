//
//  ViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 10/25/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    private let TODO_ARRAY_KEY = "TodoArray"
    
    let userDefaults = UserDefaults.standard
    
    var tasksItems = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...10 {
            let task = Task(name: "Do some work")
            tasksItems.append(task)
        }
        
        if let items = userDefaults.array(forKey: TODO_ARRAY_KEY) as? [Task] {
            tasksItems = items
        }
    }

    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        let task = tasksItems[indexPath.row]

        cell.textLabel?.text = task.name
        
        if task.isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let task = tasksItems[indexPath.row]
        task.isDone = !task.isDone
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todoey", message: "", preferredStyle: .alert)
        
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Todoey"
            textField = uiTextField
        }
        
        let addItemAction = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            
            let task = Task(name: textField.text!)
            self.tasksItems.append(task)
            
            self.userDefaults.set(self.tasksItems, forKey: self.TODO_ARRAY_KEY)
            self.tableView.reloadData()
        }
        
        alert.addAction(addItemAction)
        
        present(alert, animated: true, completion: nil)
    }
}

