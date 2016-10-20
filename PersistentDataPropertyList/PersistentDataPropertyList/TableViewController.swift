//
//  TableViewController.swift
//  PersistentDataPropertyList
//
//  Created by don't touch me on 10/20/16.
//  Copyright © 2016 trvl, LLC. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]
    
    @IBAction func addItem(_ sender: AnyObject) {
    
        //1 a new item is added to the items array
        let newRowIndex = items.count
        let item = ("Item \(newRowIndex + 1)")
        items.append(item)
        
        //2 the item is displayed below the current items in the table view
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        saveData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func saveData() {
        
        let data = NSMutableData()
        
        //1 property list will be saved in the Documents directory of the current app
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        let file = (path as NSString).appendingPathComponent("Persistent.plist")
        
        //2 NSKeyed Archiver encodes the items array and writes it to the property list
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "items")
        data.write(toFile: file, atomically: true)
        
    }
    
    func loadData() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        let file = (path as NSString).appendingPathComponent("Persistent.plist")
        
        //1 if property list exists and there is data inside it, NSKeyedUnarchiver decodes the data and puts it in the items array
        if FileManager.default.fileExists(atPath: file) {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                
                items = unarchiver.decodeObject(forKey: "items") as! [String]
                
                unarchiver.finishDecoding()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }

}
