//
//  ViewController.swift
//  Todoey
//
//  Created by Aleksandra Konopka on 10/11/2018.
//  Copyright © 2018 Aleksandra Konopka. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory ,in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Umyć głowę"
//        itemArray.append(newItem)
//        
//        let newItem1 = Item()
//        newItem1.title = "Pozmywac naczynia"
//        itemArray.append(newItem1)
//        
//        let newItem2 = Item()
//        newItem2.title = "Umyć włosy"
//        itemArray.append(newItem2)

        loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what happens when user clicks add on alert

            let newItem = Item()
            newItem.title = alert.textFields![0].text!
            
            if(alert.textFields![0].text!.count>=1)
            {
                
                self.itemArray.append(newItem)
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.saveItems()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model manipolation methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath! )
        } catch {
            print("error encoding item array : \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error encoding item array")
            }
        }
    }
}

