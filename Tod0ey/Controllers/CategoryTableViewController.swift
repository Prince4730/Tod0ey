//
//  CategoryTableViewController.swift
//  Tod0ey
//
//  Created by praveen on 01/09/19.
//  Copyright © 2019 praveen. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    
var category1=[Category1]()
let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadItems()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category1.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item=category1[indexPath.row]
        cell.textLabel!.text=item.name
        return cell
    }
//Mark 
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController=segue.destination as! ToDoListViewController
        if let indexPath=tableView.indexPathForSelectedRow
        {
           destinationViewController.selectedCategory=category1[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert = UIAlertController(title: "Add New ToDoey Ctegory", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text?.isEmpty==false{
                let newitem=Category1(context: self.context)
                
                newitem.name=textField.text!
              //  newitem.done=false
                self.category1.append(newitem)
                self.saveAction()
            }
            
            //            print(textField.text!)
        }
        alert.addAction(action)
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder="Create new item"
            textField=alerttextfield
        }
        present(alert, animated: true, completion: nil)
        
    }
    func saveAction() {
        do{
            try context.save()
        }catch
        {
            print("error is \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Category1>=Category1.fetchRequest())
    {
    // let request:NSFetchRequest<Item>=Item.fetchRequest()
    do
    {
    category1 = try context.fetch(request)
    } catch
    {
    print("error in fetching data from context  is \(error)")
    }
    
    }
}
