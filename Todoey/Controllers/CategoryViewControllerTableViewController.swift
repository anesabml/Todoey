//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 11/8/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllerTableViewController: UITableViewController {
   
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"

        return cell
    }
    
    //MARK - Adding a new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "Todoey"
            textField = uiTextField
        }
        
        let addItemAction = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            
            let category = Category()
            category.name = textField.text!
            
            self.save(category: category)
        }
        
        alert.addAction(addItemAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
          destinationVC.selectedCategory = self.categories?[indexPath.row]
        }
        
    }
    //MARK -- Data manipulation
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }

        tableView.reloadData()

    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
