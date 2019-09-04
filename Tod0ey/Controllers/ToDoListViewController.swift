//
//  ViewController.swift
//  Tod0ey
//
//  Created by praveen on 29/07/19.
//  Copyright © 2019 praveen. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController{
    var tableaviewItem=[Item]()
    
    var selectedCategory:Category1?
    {
        didSet{
            loadItems()
        }
    }
    //   let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
     let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
      
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
    //   loadItems()
//        let items=UserDefaults.standard.array(forKey: "SavedStringArray") as? [item]
//        if items?.count ?? 0 > 1
//        {
//            tableaviewItem=items!
        
//        }
        
        loadItems()
    }

//MARK- Tableview DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableaviewItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       
        let item=tableaviewItem[indexPath.row]
      //  let items=item()
        cell.textLabel?.text=item.item
//        if tableaviewItem[indexPath.row].done==true
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        else{
//             tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
    
       cell.accessoryType = item.done ? .checkmark  :.none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
//        context.delete(tableaviewItem[indexPath.row])
//        tableaviewItem.remove(at: indexPath.row)
         tableaviewItem[indexPath.row].done = !tableaviewItem[indexPath.row].done

        saveAction()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addbuttonitem(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert = UIAlertController(title: "Add New ToDoey item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add item", style: .default) { (action) in
            if textField.text?.isEmpty==false{
                let newitem=Item(context: self.context)
                
                newitem.item=textField.text!
                newitem.done=false
                newitem.parentCategory=self.selectedCategory
            self.tableaviewItem.append(newitem)
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
//    func saveAction()
//    {
//        let encoder=PropertyListEncoder()
//        do{
//            let data = try encoder.encode(self.tableaviewItem)
//            try data.write(to: self.dataFilePath!)
//        }catch{
//            print("error in encoding data \(error)")
//        }
//
//        //defaults.set(self.tableaviewItem, forKey: "SavedStringArray")
//        self.tableView.reloadData()
//    }
    func saveAction()
    {
        do{
            try context.save()
        }catch
        {
            print("error is \(error)")
        }
         self.tableView.reloadData()
        }
   
//    func loadItems()
//    {
//        if let data = try? Data(contentsOf: dataFilePath!)
//        {
//         let decoder=PropertyListDecoder()
//            do
//            {
//                tableaviewItem=try decoder.decode([item].self, from: data)
//            }
//                catch{
//                    print("error in decoding data is \(error)")
//
//
//            }
//        }
//
//    }
    func loadItems(with request:NSFetchRequest<Item>=Item.fetchRequest(),predicate:NSPredicate?=nil)
    {
        let categoryPredicate=NSPredicate(format: "parentCategory.name Matches %@", (selectedCategory!.name!))
        if let addtionalPredicate=predicate
        {
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }
        else
        {
            request.predicate=categoryPredicate
        }
        //let compoundPredicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        
       // let request:NSFetchRequest<Item>=Item.fetchRequest()
        do
        {
           tableaviewItem=try context.fetch(request)
        }catch
        {
            print("error in fetching data from context  is \(error)")
        }
        
        
    }
    
}
//Mark: -Search bar methods
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        // print(searchBar.text!)
        let predicate=NSPredicate(format: "item contains[c] %@", searchBar.text!)
        print(predicate)
        request.predicate=predicate
       

        //request.predicate=NSPredicate(format: "name contains[c] %@", searchBar.text!)
       request.sortDescriptors=[NSSortDescriptor(key: "item", ascending: true)]
       loadItems(with: request,predicate:predicate)

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//    }
}
