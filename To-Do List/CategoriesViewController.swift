//
//  ViewController.swift
//  To-Do List
//
//  Created by Azimjonoff on 12/06/23.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var categories = [Category]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To-Do List Categories"
        tableView.rowHeight = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        if let savedCategories = defaults.object(forKey: "categories") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                categories = try jsonDecoder.decode([Category].self, from: savedCategories)
            } catch {
                print("Failed to load categories")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Items") as? ItemsViewController{
            vc.categoryName = categories[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            let categoryName = self?.categories[indexPath.row].name
            self?.categories.remove(at: indexPath.row)
            self?.save()
            self?.defaults.removeObject(forKey: categoryName!)
            self?.tableView.reloadData()
            completionHandler(true)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    @objc func addCategory() {
        let ac = UIAlertController(title: "New Category", message: "Enter a name for a new To-Do category", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak ac] action in
            if let newCategoryName = ac?.textFields?[0].text {
                let newCategory = Category(name: newCategoryName, items: [])
                self?.categories.append(newCategory)
                self?.save()
                self?.tableView.reloadData()
            }
        }))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(categories) {
            defaults.set(savedData, forKey: "categories")
        } else {
            printContent("Failed to save people")
        }
    }
}
