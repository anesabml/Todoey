//
//  ViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 10/25/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var todoItems = ["Book a trip", "Do nothing", "Also do nothing", "Go to sleep"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        cell.textLabel?.text = todoItems[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todoey", message: "", preferredStyle: .alert)
        
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Todoey"
            textField = uiTextField
        }
        
        let addItemAction = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            let task = textField.text!
            self.todoItems.append(task)
            self.tableView.reloadData()
        }
        
        alert.addAction(addItemAction)
        
        present(alert, animated: true, completion: nil)
    }
}

