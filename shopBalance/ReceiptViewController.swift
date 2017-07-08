//
//  ReceiptViewController.swift
//  shopBalance
//
//  Created by Paul Crews on 7/7/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import CoreData

class ReceiptViewController: UIViewController {
    
    var list : List? = nil
    var listArray : [List] = []
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var itemQt: UITextField!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var ttl: UILabel!
    @IBOutlet weak var budget: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    var bgt:Double = 0.00
    var all:Double = 0.00
    
    override func viewWillAppear(_ animated: Bool) {
        itemInfo()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        
        if let index = listArray.index(of: items){
            listArray.remove(at: index)
        }
        getBalance()
        getTotal()
        
        myTable.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        
        if let index = listArray.index(of: items){
            if items.name == nil{
                listArray.remove(at: index)
            }
        }
        items.balance = Double(items.budget) - Double(items.total)
        
        if items.balance == 0{
            balance.text = String("\(Double(0.00))")
        }else{
            balance.text = ("\(Double(items.balance))")
        }
        
        total.text = ("\(Double(bgt))")
        budget.text = ("\(Double(items.budget))")
    }
    
    
    func itemInfo(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            listArray = try context.fetch(List.fetchRequest()) as! [List]
        }catch{
            
        }
    }
    
    
    @IBAction func updatePressed(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        
        items.budget = Double("\(budget.text!)")!
        
        getTotal()
        
        listArray.append(items)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.view.endEditing(true)
        
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        items.budget = Double("\(budget.text!)")!
        items.id = 3
        items.name = itemName.text!
        items.quantity =  Int32(itemQt.text!)!
        items.price = Double(itemPrice.text!)!
        let cost = Double(itemPrice.text!)! * Double(itemQt.text!)!
        items.total = Double(cost)
        total.text = String(Double(total.text!)! + Double(cost))
        balance.text = String("$ \(Double(budget.text!)! - Double(total.text!)!)")
        
        if items.name != nil{
            listArray.append(items)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        myTable.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if listArray.count == 0{
            cell.textLabel?.text = "🤔 Nothing here yet 🤔"
            cell.textLabel?.textAlignment = .center
        }else{
            
            let items = listArray[indexPath.row]
            
            if items.name != nil{
                cell.textLabel?.text = String("\(indexPath.row + 1).) | \(items.quantity) |\(items.name!) | \(items.price)" )
            }else{
                if let index = listArray.index(of: items){
                    listArray.remove(at: index)
                }
                myTable.reloadData()
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listArray.count == 0{
            return 1
        }else{
            return listArray.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if listArray.count == 0 {
            
        }else{
            let grocery = listArray[indexPath.row]
            list = grocery
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(grocery)
            removeListItem()
            getTotal()
            myTable.reloadData()
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func removeListItem(){
        if let index = listArray.index(of: list!){
            listArray.remove(at: index)
        }
    }
    func getTotal(){
        all = 0.0
        if listArray.count > 0 {
            for i in 0...listArray.count - 1{
                all = Double(Double(listArray[i].price) * Double(listArray[i].quantity)) + all
                
            }
        }
        total.text = ("\(Double(all))")
        myTable.reloadData()
        getBalance()
        
    }
    func getBalance(){
        
        balance.text = String("\( Double(budget.text!)! - Double(total.text!)!)")
    }
}
