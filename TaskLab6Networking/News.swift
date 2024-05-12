//
//  News.swift
//  TaskLab6Networking
//
//  Created by Marim Mohamed Mohamed Yacout on 29/04/2024.
//

import Foundation

class News:Codable {
    var author : String?
    var title : String?
    var desription : String?
    var imageUrl : String?
    var publishedAt :String?
    init(author: String, title: String, description: String, imageUrl: String, publishedAt: String) {
            self.author = author
            self.title = title
            self.desription = description
            self.imageUrl = imageUrl
            self.publishedAt = publishedAt
        }
}


func getDataFromApi(handler :@escaping ([News]) -> Void){
    let url = URL (string: "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json")
       
       guard let url = url else{
           print("error url")
           return
       }
       let request = URLRequest(url: url)
       
       let session = URLSession(configuration: .default)
      
       let task = session.dataTask(with: request){data ,response ,error in
           
           guard let data = data else{
               print("no data")
               return
           }
           do{
    //                let json = try JSONSerialization.jsonObject(with: data , options: .allowFragments) as! Array<Dictionary<String,String>>
    //                print(json[0] ["title"] ?? "No title")
               let result = try JSONDecoder().decode([News].self, from: data)
                              handler(result)
               
           }
           catch{
               print(error.localizedDescription)
           }
           
       }
       task.resume()

}


