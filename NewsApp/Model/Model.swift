//
//  Model.swift
//  NewsApp
//
//  Created by Pavel Bondar on 10/27/19.
//  Copyright © 2019 Pavel Bondar. All rights reserved.
//

import Foundation

var articles:[Article] = []
//Your API key is: 84a521a08cf141aa8bbe269df5f99439
func loadNews() {
    let url = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&from=2019-09-27&sortBy=publishedAt&apiKey=API_KEY")
    let session = URLSession(configuration: .default)
    let downloadTask = session.downloadTask(with: url!) { (urlFile, responce, error) in
        if urlFile != nil {
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/data.json"
            let urlPath = URL(fileURLWithPath: path)
            try? FileManager.default.copyItem(at: urlFile!, to: urlPath)
            
            print(urlPath)
            
            parseNews()
            
            print(articles.count)
        }
    }
    
    downloadTask.resume()
}

func parseNews() {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/data.json"
    let urlPath = URL(fileURLWithPath: path)
    
    let data = try? Data(contentsOf: urlPath)
    let rootDictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
    let array = rootDictionary!["articles"] as! [Dictionary<String, Any>]
    
    var returnArray: [Article] = []
    
    for dict in array {
        let newArticle = Article(dictionary: dict)
        returnArray.append(newArticle)
    }
    articles = returnArray
}
