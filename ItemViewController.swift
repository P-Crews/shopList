//
//  ItemViewController.swift
//  shopBalance
//
//  Created by Paul Crews on 7/5/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var myTable: UITableView!
    
    var myList : Groceries? = nil
    var myListArray : [Groceries] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems()
        myTable.reloadData()
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = Groceries(context: context)
        items.done = false
        items.quantity = Int16(quantity.text!)!
        items.name = itemName.text!
        
        myListArray.append(items)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        myTable.reloadData()
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if myListArray.count == 0{
            
        }else{
            let grocery = myListArray[indexPath.row]
            myList = grocery
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            grocery.done = true
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //            context.delete(grocery)
            //            removeListItem()
            myTable.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myListArray.count == 0{
            return 1
        }else{
            return myListArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if myListArray.count == 0 {
            cell.textLabel?.text = "🤔 Nothing here yet 🤔"
            cell.textLabel?.textAlignment = .center
        }else{
            
            let items = myListArray[indexPath.row]
            if items.done == true{
                cell.textLabel?.text = String("✅ \(items.quantity) | \(items.name!)")
            }else{
                cell.textLabel?.text = String("\(items.quantity) | \(items.name!)")
            }
        }
        return cell
    }
    
    func removeListItem(){
        if let index = myListArray.index(of: myList!){
            myListArray.remove(at: index)
        }
    }
    func getItems(){
        let savedList = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            myListArray = try savedList.fetch(Groceries.fetchRequest()) as [Groceries]
        }catch{
            
        }
        
    }
}
