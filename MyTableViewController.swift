//
//  MyTableViewController.swift
//  shopBalance
//
//  Created by Paul Crews on 7/5/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import CoreData

class MyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
       
        items.balance = Double(items.budget) - Double(items.total)
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        if items.balance == 0{
            balance.text = String("\(Double(0.00))")
        }else{
            balance.text = ("\(Double(items.balance))")
        }
        
        total.text = ("\(Double(items.total))")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        
        total.text = ("\(Double(items.total))")
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
        let lister = List(context: context)
        lister.budget = Double(budget.text!)!
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print(lister.budget)
        balance.text = String("\( Double(lister.budget) - Double(lister.total))")
        
        self.view.endEditing(true)
        
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        print(total.text!)
        items.budget = Double("\(budget.text!)")!
        items.id = 3
        items.name = itemName.text!
        items.quantity =  Int32(itemQt.text!)!
        items.price = Double(itemPrice.text!)!
        let cost = Double(itemPrice.text!)! * Double(itemQt.text!)!
        items.total = Double(cost)
        print(items)
        total.text = String(Double(total.text!)! + Double(cost))
        balance.text = String("$ \(Double(budget.text!)! - Double(total.text!)!)")
        
        listArray.append(items)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        myTable.reloadData()
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        let items = listArray[indexPath.row]
        
        //FIND OUT WHY THE FUCK LIST ARRAY IS GENERATING SHIT
        
        if items.total == 0.0{
            cell.textLabel?.text = String("\(listArray[indexPath.row].name)")
        }
        else{
            cell.textLabel?.text = String("\(indexPath.row + 1).) | \(items.quantity) |\(items.name!) | \(items.price)" )
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let items = List(context: context)
        
        return listArray.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grocery = listArray[indexPath.row]
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(grocery)
        tableView.reloadData()
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    


   }
