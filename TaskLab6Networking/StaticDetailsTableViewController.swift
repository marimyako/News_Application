//
//  StaticDetailsTableViewController.swift
//  TaskLab6Networking
//
//  Created by Marim Mohamed Mohamed Yacout on 01/05/2024.
//

import UIKit
import CoreData
class StaticDetailsTableViewController: UITableViewController {
    var news: News?
    var isDataSaved :Bool?
    @IBOutlet weak var favbtn: UIButton!
    @IBAction func fav(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext
               
               if let new = news {
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "New")
                   let predicate = NSPredicate(format: "title = %@", new.title!)
                   fetchRequest.predicate = predicate
                   
                   do {
                       let result = try context.fetch(fetchRequest)
                       if result.isEmpty {
                           
                           let entity = NSEntityDescription.entity(forEntityName: "New", in: context)
                           let newManagedObject = NSManagedObject(entity: entity!, insertInto: context)
                           if let title = Sdtitle.text as NSString?,
                              let author = Sdanthor.text as NSString?,
                              let description = Sddesc.text as NSString?,
                              let publishAt = Sdpublish.text as NSString?,
                              let image = Sdimage.image,
                              let imageData = image.jpegData(compressionQuality: 1.0) {
                               
                               let base64String = imageData.base64EncodedString(options: [])
                               
                               newManagedObject.setValue(title, forKey: "title")
                               newManagedObject.setValue(author, forKey: "author")
                               newManagedObject.setValue(description, forKey: "desription")
                               newManagedObject.setValue(base64String, forKey: "imageurl")
                               newManagedObject.setValue(publishAt, forKey: "publishat")
                               
                               try context.save()
                               isDataSaved = true
                               print("Data saved")
                           }
                       } else {
                           context.delete(result.first as! NSManagedObject)
                           try context.save()
                           isDataSaved = false
                       }
                       
                       updateFavButtonAppearance()
                       
                 
                   } catch {
                       print("Failed to perform fetch: \(error.localizedDescription)")
                   }
               }
    }
    @IBOutlet weak var Sdpublish: UILabel!
    @IBOutlet weak var Sddesc: UITextView!
    @IBOutlet weak var Sdtitle: UILabel!
    @IBOutlet weak var Sdanthor: UILabel!
    @IBOutlet weak var Sdimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let new = news {
            Sdtitle.text = new.title
            Sddesc.text = new.desription
            Sdanthor.text=new.author
            Sdpublish.text=new.publishedAt
            if let imageUrlString = new.imageUrl,
               let imageData = Data(base64Encoded: imageUrlString),
               let image = UIImage(data: imageData){
                Sdimage.image = image
            }else{
                Sdimage.image = UIImage(named: "meduim.png")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isDataSaved = isNewsSaved()
        updateFavButtonAppearance()
    }
    func isNewsSaved() -> Bool {
          guard let new = news else { return false }
          
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "New")
        let predicate = NSPredicate(format: "title = %@", new.title!)
          fetchRequest.predicate = predicate
          
          do {
              let result = try context.fetch(fetchRequest)
              return !result.isEmpty
          } catch {
              print("Failed to perform fetch: \(error.localizedDescription)")
              return false
          }
      }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateFavButtonAppearance() {
        if isDataSaved! {
                favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favbtn.tintColor = .red
            } else {
                favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
                favbtn.tintColor = .blue
            }
        }

}
