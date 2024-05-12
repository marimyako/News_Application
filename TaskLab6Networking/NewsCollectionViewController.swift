//
//  NewsCollectionViewController.swift
//  TaskLab6Networking
//
//  Created by Marim Mohamed Mohamed Yacout on 29/04/2024.
//

import UIKit
import Reachability
import CoreData
import SDWebImage

private let reuseIdentifier = "Cell"

class NewsCollectionViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout {
    var indicator :UIActivityIndicatorView?
    var news: [News] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let reachability = try! Reachability()
         
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if reachability.connection != .unavailable {
                   
                    indicator = UIActivityIndicatorView(style: .medium)
                    indicator!.center = view.center
                    indicator!.startAnimating()
                    view.addSubview(indicator!)
                    getDataFromApi { [weak self] news in
                        self?.news = news
                        DispatchQueue.main.async {
                            self?.indicator?.stopAnimating()
                            self?.collectionView.reloadData()
                            self?.dataToCoreData()
                            print("data come from api")
                        }
                    }
                } else {
                  
                    dataFromCoreData()
                    print("data come from coredata")
                }
        
    }
    func dataToCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllNews")
        
        do {
    
            let existingData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
        
            for newsItem in existingData {
                context.delete(newsItem)
            }
            
    
            for newsItem in news {
                let entity = NSEntityDescription.entity(forEntityName: "AllNews", in: context)!
                let new = NSManagedObject(entity: entity, insertInto: context)
                new.setValue(newsItem.author, forKeyPath: "author")
                new.setValue(newsItem.imageUrl, forKeyPath: "imageurl")
                new.setValue(newsItem.title, forKeyPath: "title")
                new.setValue(newsItem.desription, forKeyPath: "desription")
                new.setValue(newsItem.publishedAt, forKeyPath: "publishat")
            }
            
            try context.save()
        } catch {
            print("not deletedd ")
        }
    }
    func dataFromCoreData() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "AllNews")
            do {
                let news = try context.fetch(fetchReq)
                for new in news {
                    if let author = new.value(forKey: "author") as? String,
                       let imageUrl = new.value(forKey: "imageurl") as? String,
                       let title = new.value(forKey: "title") as? String,
                       let description = new.value(forKey: "desription") as? String,
                       let publishAt = new.value(forKey: "publishat") as? String {
                        let news = News(author: author, title: title, description: description, imageUrl: imageUrl, publishedAt: publishAt)
                        self.news.append(news)
                    }
                }
                self.collectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        print("data come from coredata")
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180,height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let currentNews = news[indexPath.item]
               cell.title.text = currentNews.author
               
        if let imageUrlString = currentNews.imageUrl, let imageUrl = URL(string: imageUrlString) {
              
                cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "meduim"))
            } else {
                cell.imageView.image = nil
            }
               
               return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNew = news[indexPath.row]
        details(for: selectedNew)
    }
    func details(for news:News) {
        let newsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticDetailsTableViewController") as! StaticDetailsTableViewController
        newsDetailVC.news = news
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
    }

    
  
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */


