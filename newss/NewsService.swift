//
//  NewsService.swift
//  newss
//
//  Created by Mishel on 05.02.2024.
//

import Foundation
import UIKit

class NewsService {

    func fetchNews(completion: @escaping ([News]) -> Void) { //замыкание для загрузки
        let apiKey = "a98ceab1734f40038863275a973d407a"
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let articles = json?["articles"] as? [[String: Any]] {
                            var news: [News] = []
                            for article in articles {
                                if let title = article["title"] as? String,
                                   let description = article["description"] as? String,
                                   let urlString = article["url"] as? String,
                                   let url = URL(string: urlString),
                                   let imageUrlString = article["urlToImage"] as? String,
                                   let imageUrl = URL(string: imageUrlString),
                                   let imageData = try? Data(contentsOf: imageUrl),
                                   let image = UIImage(data: imageData) {
                                   let newsItem = News(title: title, description: description, image: image, url: url)
                                    news.append(newsItem)
                                }
                            }
                            completion(news)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}
