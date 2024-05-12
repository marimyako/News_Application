//
//  FavTableViewController.swift
//  TaskLab6Networking
//
//  Created by Marim Mohamed Mohamed Yacout on 30/04/2024.
//

import UIKit
import CoreData

class FavTableViewController: UITableViewController {
    var newsArray: [News] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      getFavData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func getFavData(){
       
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "New")
        do{
           let news = try context.fetch(fetchReq)
            for new in news {
                if let author = new.value(forKey: "author") as? String,
                               let imageUrl = new.value(forKey: "imageurl") as? String,
                               let title = new.value(forKey: "title") as? String,
                               let description = new.value(forKey: "desription") as? String,
                               let publishAt = new.value(forKey: "publishat") as? String {
                                
    let news = News(author: author, title: title, description: description,imageUrl: imageUrl, publishedAt: publishAt)
                                newsArray.append(news)
                            }
                
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
//    func deleteData(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               let context = appDelegate.persistentContainer.viewContext
//        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "New")
//        do{
//            let news = try context.fetch(fetchReq)
//            for new in news {
//                context.delete(new)
//                print ("deleted")
//            }
//            try context.save()
//        }catch{
//            
//        }
//    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fcell", for: indexPath)

        let news = newsArray[indexPath.row]
            
            cell.textLabel?.text = news.title
            
           
        if let imageUrlString = news.imageUrl,
           let imageData = Data(base64Encoded: imageUrlString),
           let image = UIImage(data: imageData){
            cell.imageView?.image = image
        }else{
            cell.imageView?.image = UIImage(named: "meduim.png")
        }
            
            return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNew = newsArray[indexPath.row]
        details(for: selectedNew)
    }
    func details(for newArray:News) {
        let newsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticDetailsTableViewController") as! StaticDetailsTableViewController
        newsDetailVC.news = newArray
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newsToDelete = newsArray[indexPath.row]
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "New")
         let predicate = NSPredicate(format: "title = %@", newsToDelete.title!)
            fetchRequest.predicate = predicate
            do {
                let result = try context.fetch(fetchRequest)
                if let objectToDelete = result.first as? NSManagedObject {
                    context.delete(objectToDelete)
                    try context.save()
                    newsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("not deleteeed")
            }
        }
    }

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

}
