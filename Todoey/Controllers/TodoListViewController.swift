//
//  ViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 10/25/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
  
    let realm = try! Realm()
    var tasksItems : Results<Task>?
    var selectedCategory :Category? {
        didSet {
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        if let task = tasksItems?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No task added yet"
        }

        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let task = tasksItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(task)
                    task.isDone = !task.isDone
                }
            } catch {
                print("Error updating task \(error)")
            }
        }
        
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
            
            if let parentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let task = Task()
                        task.title = textField.text!
                        parentCategory.tasks.append(task)
                    }
                } catch {
                    print("Error saving task \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addItemAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK -- Data manipulation
    
    func loadTasks() {
        tasksItems = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Task> = Task.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadTasks(with: request)
//    }

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadTasks()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            tasksItems = tasksItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
    }

}
