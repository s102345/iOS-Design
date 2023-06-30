//
//  ViewController.swift
//  MyCoreData
//
//  Created by Mac10 on 2023/5/11.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var carplate: UITextField!
    @IBOutlet weak var clientid: UITextField!
    @IBOutlet weak var clientName: UITextField!
    
    
    @IBAction func clickreturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func clearinfo(_ sender: Any) {
        clientName.text = ""
        clientid.text = ""
        carplate.text = ""
        MyImage.image = nil
    }
    
   
    @IBAction func selected(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        show(imagePicker, sender: MyImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for i in 1...6{
//            print("0\(i).jpg")
//            if let image = UIImage(named: "0\(i).jpg"){
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//        }
        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        print(NSPersistentContainer.defaultDirectoryURL())
        //deleteAllUserData()
        //insertUserData()
        //queryAllUserData()
        //queryWithPredicate()
        //storedFetch()
        //insert_onetoMany()
        //query_onetoMany()
        
        saveImage()
        loadImage()
    }
    func storedFetch(){
        let model = app.persistentContainer.managedObjectModel
        if let fetchRequest = model.fetchRequestTemplate(forName: "FtchRst_cname_BeginsA"){
            do{
                let allUsers = try viewContext.fetch(fetchRequest)
                for user in allUsers as! [UserData]{
                    print("\((user.cid)!) \((user.cname)!)")
                }
            }
            catch{
                print(error)
            }
        }
    }
    func loadImage(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'M111888999'")
        fetchRequest.predicate = predicate
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers{
                MyImage.image = UIImage(data: user.cimage! as Data)
            }
        } catch{
            print(error)
        }
    }
    func insert_onetoMany(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M11015019"
        user.cname = "Nick"
        
        var car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "811-NGC"
        user.addToOwn(car)
        
        car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "PCN-0417"
        user.addToOwn(car)
        app.saveContext()
    }
    
    func query_onetoMany(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'M11015019'")
        fetchRequest.predicate = predicate
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers{
                if user.own == nil{
                    print("\((user.cname)!), 沒有車")
                }
                else{
                    print("\((user.cid)!) 有 \((user.own?.count)!) 部車")
                    for car in user.own as! Set<Car>{
                        print("車牌是 \((car.plate)!)")
                    }
                }
            }
        }catch{
            print(error)
        }
    }
    
    
    func insertUserData(){
        var user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M11015019"
        user.cname = "Nick"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815069"
        user.cname = "Abby"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815060"
        user.cname = "Andy"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815071"
        user.cname = "Alex"
        
        app.saveContext()
    }
    
    func queryAllUserData(){
        do{
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData]{
                print("\((user.cid)!) , \((user.cname)!)")
            }
            let allcarUsers = try viewContext.fetch(UserData.fetchRequest())
            for car in allcarUsers{
                viewContext.delete(car)
            }
            app.saveContext()
            print("Successful delete!")
        }
        catch{
            print(error)
        }
    }
    
    func deleteAllUserData(){
        do{
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData]{
                viewContext.delete(user)
            }
            app.saveContext()
            print("Successful delete")
        }
        catch{
            print(error)
        }
    }
    
    func queryWithPredicate(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cname like 'A*'")
        fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: "cid", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers{
                print("\((user.cid)!) , \((user.cname)!)")
            }
        }
        catch{
            print(error)
        }
    }
    
    func saveImage(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M111888999"
        user.cname = "Serena"
        let image = UIImage(named : "03.jpg")
        let imageData = image?.pngData()
        user.cimage = imageData
        app.saveContext()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        MyImage.image = image
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveData(_ sender: UIButton) {
        if(clientid.text == "") || (clientName.text == "") || (carplate.text == "") || (MyImage.image == nil){
            MyAlertController("Error")
        }
        else{
            let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
            user.setValue(clientName.text, forKey: "cname")
            user.setValue(clientid.text, forKey: "cid")
            user.setValue(MyImage.image?.pngData(), forKey: "cimage")
            let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
            car.setValue(carplate.text, forKey: "plate")
            user.addToOwn(car)
            app.saveContext()
            MyAlertController("Successful insert")
        }
    }
    func MyAlertController(_ result: String){
        var alert = UIAlertController()
        if result == "Error"{
            alert = UIAlertController(title: "Error", message: "Please enter complete information", preferredStyle: .alert)
        }
        else if(result == "Successful insert"){
            alert = UIAlertController(title: "Successful insert", message: String(clientName.text!) + " added finish", preferredStyle: .alert)
        }
        else{
            alert = UIAlertController(title: "Unsuccessful load", message: "There is no such data", preferredStyle: .alert)
        }
        let action = UIAlertAction(title: "I got it", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loadData(_ sender: UIButton) {
        let fetchId = NSPredicate(format: "cid BEGINSWITH[cd] %@", clientid.text!)
        let fetchName = NSPredicate(format: "cname BEGINSWITH[cd] %@", clientName.text!)
        let fetchPlate = NSPredicate(format: "plate == %@", carplate.text!)
        let fetchRequest : NSFetchRequest<UserData> = UserData.fetchRequest()
        var predicate = NSCompoundPredicate()
        if (carplate.text != ""){
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchPlate])
            let fetchCarRequest: NSFetchRequest<Car> = Car.fetchRequest()
            fetchCarRequest.predicate = predicate
            do{
                let Cars = try viewContext.fetch(fetchCarRequest)
                if Cars == []{
                    MyAlertController("Unsuccessful load")
                }
                for car in Cars{
                    carplate.text = car.plate
                    if let user = car.belongto{
                        clientid.text = user.cid
                        clientName.text = user.cname
                        MyImage.image = UIImage(data: user.cimage! as Data)
                    }
                }
            }catch{
                print(error)
            }
        }
        else{
            if (clientid.text != "") && (clientName.text == ""){
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId])
            }
            else if (clientid.text == "") && (clientName.text != ""){
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchName])
            }
            else{
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId,fetchName])
            }
            fetchRequest.predicate = predicate
            do{
                let Users = try viewContext.fetch(fetchRequest)
                if Users == []{
                    MyAlertController("Unsuccessful load")
                }
                for user in Users{
                    clientid.text = user.cid
                    clientName.text = user.cname
                    MyImage.image = UIImage(data: user.cimage! as Data)
                    for car in user.own as! Set<Car>{
                        carplate.text = car.plate
                    }
                }
            }catch{
                print(error)
            }
        }
    }
}

