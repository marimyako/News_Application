//
//  DetailsViewController.swift
//  TaskLab6Networking
//
//  Created by Marim Mohamed Mohamed Yacout on 29/04/2024.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    var news: News?
    
    
    
    var isDataSaved :Bool?
    @IBOutlet weak var dPublishAT: UILabel!
    @IBOutlet weak var dDesc: UITextView!
    @IBOutlet weak var dAuther: UILabel!
    @IBOutlet weak var dImage: UIImageView!
    @IBOutlet weak var dTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //.register(UITableViewCell.self, forCellReuseIdentifier: "fcell")
        // Do any additional setup after loading the view.
        
        if let new = news {
            dTitle.text = new.title
            dDesc.text = new.desription
            dAuther.text=new.author
            dPublishAT.text=new.publishedAt
            if let imageUrlString = new.imageUrl,
               let imageData = Data(base64Encoded: imageUrlString),
               let image = UIImage(data: imageData){
                dImage.image = image
            }else{
                dImage.image = UIImage(named: "meduim.png")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
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
                           if let title = dTitle.text as NSString?,
                              let author = dAuther.text as NSString?,
                              let description = dDesc.text as NSString?,
                              let publishAt = dPublishAT.text as NSString?,
                              let image = dImage.image,
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
