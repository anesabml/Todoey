//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Anes Abismail on 11/8/19.
//  Copyright © 2019 Anes Abismail. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
   
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCelll", for: indexPath)

        let category = categories[indexPath.row]

        cell.textLabel?.text = category.name

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
            
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categories.append(category)
            
            self.saveCategories()
            
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
          destinationVC.selectedCategory = self.categories[indexPath.row]
        }
        
    }
    //MARK -- Data manipulation
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        tableView.reloadData()

    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
}
