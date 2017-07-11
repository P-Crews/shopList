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
        self.myTable.sectionHeaderHeight = 40
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if itemName.text == "" || quantity.text == ""{
            
            let alert = UIAlertController(title: "🛑❗️❗️❗️", message: "Please fill in all fields❗️", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            })
            alert.addAction(ok)
            self.present(alert, animated: true)
        }else{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = Groceries(context: context)
        items.done = false
        items.quantity = Int16(quantity.text!)!
        items.name = itemName.text!
        
        myListArray.append(items)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        myTable.reloadData()
        self.view.endEditing(true)
        quantity.text = nil
        itemName.text = nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! MyTableViewCell
        
        head.idLabel.text = "ID"
        head.quantityLabel.text = "Quantity"
        head.itemLabel.text = "Item"
        
        return head
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = UITableViewCell()
        if myListArray.count == 0{
            
        }else{
            let grocery = myListArray[indexPath.row]
            myList = grocery
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            if grocery.done == true{
            context.delete(grocery)
                removeListItem()
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }else{
                grocery.done = true
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
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
        
        if myListArray.count == 0 {
            
            let cell = UITableViewCell()
            cell.textLabel?.text = "🤔 Nothing here yet 🤔"
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.clear
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! MyTableViewCell
            let items = myListArray[indexPath.row]
            if items.done == true{
                
                cell.listId?.text = String("\(indexPath.row + 1). ")
                cell.itemDone.text = "✅ "
                cell.listName.text = items.name
                
                return cell
            }else{
                cell.listId?.text = String("\(indexPath.row + 1). ")
                cell.itemDone.text = String(items.quantity)
                cell.listName.text = items.name
                return cell
            }
        }
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
