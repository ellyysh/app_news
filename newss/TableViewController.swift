//
//  TableViewController.swift
//  newss
//
//  Created by Mishel on 30.01.2024.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var news: [News] = [] // Массив новостей
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загрузка новостей из API
        fetchNews()
        
      
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    func fetchNews() {
        let apiKey = "a98ceab1734f40038863275a973d407a"
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let articles = json?["articles"] as? [[String: Any]] {
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
                                    self.news.append(newsItem)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        
        let currentNews = news[indexPath.row]
        cell.textLabel?.text = currentNews.title
        cell.detailTextLabel?.text = currentNews.description
        cell.imageView?.image = currentNews.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        // Действия при выборе новости
        if let url = selectedNews.url {
            UIApplication.shared.open(url)
        }
    }
}

