//
//  ItemsViewController.swift
//  To-Do List
//
//  Created by Azimjonoff on 12/06/23.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var categoryName: String = ""
    var items: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryName
        tableView.rowHeight = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        if let savedItems = defaults.object(forKey: categoryName) as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                items = try jsonDecoder.decode([Item].self, from: savedItems)
            } catch {
                print("Failed to load items")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        save()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.items.remove(at: indexPath.row)
            self?.save()
            self?.tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @objc func addNewItem() {
        let ac = UIAlertController(title: "New item", message: "Enter a name for a new To-Do item", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak ac] action in
            if let newItemName = ac?.textFields?[0].text! {
                let newItem = Item(name: newItemName, done: false)
                self?.items.append(newItem)
                self?.save()
                self?.tableView.reloadData()
            }
        }))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(items) {
            defaults.set(savedData, forKey: categoryName)
        } else {
            printContent("Failed to save items")
        }
    }
}
