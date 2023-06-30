//
//  TableViewController.swift
//  HW2
//
//  Created by  陳奕軒 on 2023/3/16.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.isEditing = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    var names = ["八倍蛋歐姆蛋包飯", "草莓大福", "抹茶拿鐵", "阿娘喂", "咖哩雞排烏龍燴麵", "照燒雞拌飯", "奢華海鮮丼", "雙響砲", "醬燒烤雞肉三明治"]
    var images = ["8eggrice.png", "bread.png", "latte.jpg", "liao.png", "noodles.png", "normal_ricerolls.png", "rich_riceroll.png", "instant_noodle.png", "sandwich.png"]
    var prices = [109,39,39, 60,99,23,59,33,59]

    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var insertButton: UIBarButtonItem!
    
    var state = "None"
    
    var nameSent: String? = nil
    var imageSent: String? = nil
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    @IBAction func switchDelete(_ sender: UIBarButtonItem) {
        if state == "None"{
            deleteButton!.title = "返回"
            state = "Delete"
            tableView.isEditing = true
        }
        else if state == "Delete"{
            deleteButton!.title = "刪除"
            state = "None"
            tableView.isEditing = false
        }
        else{
            return
        }
    }
    
    @IBAction func switchInsert(_ sender: UIBarButtonItem) {
        if state == "None"{
            insertButton!.title = "返回"
            state = "Insert"
            tableView.isEditing = true
        }
        else if state == "Insert"{
            insertButton!.title = "新增"
            state = "None"
            tableView.isEditing = false
        }
        else{
            return
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
    
        // Configure the cell...
        cell.nameLabel?.text = names[indexPath.row]
        cell.thumbnail?.image = UIImage(named: images[indexPath.row])
        cell.priceLabel?.text = "\(prices[indexPath.row])元"
        return cell
    }
    


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            names.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            prices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let tmpText = names[indexPath.row]
            let tmpImg = images[indexPath.row]
            let tmpPrice = prices[indexPath.row]
            names.insert(tmpText, at: indexPath.row)
            images.insert(tmpImg, at: indexPath.row)
            prices.insert(tmpPrice, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }    
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if state == "Insert"{
            return UITableViewCell.EditingStyle.insert
        }
        else if state == "Delete"{
            return UITableViewCell.EditingStyle.delete
        }
        else{
            return UITableViewCell.EditingStyle.none
        }
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let tmpText = names[fromIndexPath.row]
        let tmpImg = images[fromIndexPath.row]
        let tmpPrice = prices[fromIndexPath.row]
        
        names.remove(at: fromIndexPath.row)
        images.remove(at: fromIndexPath.row)
        prices.remove(at: fromIndexPath.row)
        
        names.insert(tmpText, at: to.row)
        images.insert(tmpImg, at: to.row)
        prices.insert(tmpPrice, at: to.row)
        
        tableView.reloadData()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameSent = names[indexPath.row]
        imageSent = images[indexPath.row]
        performSegue(withIdentifier: "segue_cellToView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_cellToView"{
            let vc = segue.destination as? ViewController
            vc!.nameReceived = nameSent
            vc!.imageReceived = imageSent
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
