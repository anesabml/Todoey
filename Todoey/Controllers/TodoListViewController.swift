//
//  ViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 10/25/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  
    var tasksItems = [Task]()
    var selectedCategory :Category? {
        didSet {
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
    }

    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        let task = tasksItems[indexPath.row]

        cell.textLabel?.text = task.title
        
        cell.accessoryType = task.isDone ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        context.delete(tasksItems[indexPath.row])
//        tasksItems.remove(at: indexPath.row)
        
        let task = tasksItems[indexPath.row]
        task.isDone = !task.isDone
        
        self.saveTasks()
        
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
            
            let task = Task(context: self.context)
            task.title = textField.text!
            task.parentCategory = self.selectedCategory
            
            self.tasksItems.append(task)
            
            self.saveTasks()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(addItemAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK -- Data manipulation
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            tasksItems = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
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
            let request : NSFetchRequest<Task> = Task.fetchRequest()
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadTasks(with: request, predicate: searchPredicate)
        }
    }
}
