//
//  ViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 10/25/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
  
    let realm = try! Realm()
    var tasksItems : Results<Task>?
    var selectedCategory :Category? {
        didSet {
            loadTasks()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let hexColor = selectedCategory?.color {
            updateUi(withHexColor: hexColor)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateUi(withHexColor: "009193")
    }
    
    func updateUi(withHexColor hexColor: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("No navigation bar") }
        guard let color = UIColor(hexString: hexColor) else { fatalError("Wrong hex code") }
        
        navBar.barTintColor = color
        searchBar.barTintColor = color
        
        let contrastColor = ContrastColorOf(color, returnFlat: true)
        navBar.tintColor = contrastColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
    }
    
    //MARK - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let task = tasksItems?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.isDone ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(tasksItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
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
    
    override func updateData(at indexPath: IndexPath) {
        if let task = tasksItems?[indexPath.row] {
            do {
                try realm.write {
                        realm.delete(task)
                }
            } catch {
                print("Error deleting task \(error)")
            }
        }
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
