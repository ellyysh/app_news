//
//  TableViewController.swift
//  newss
//
//  Created by Mishel on 30.01.2024.
//

import UIKit

class NewsTableViewController: UITableViewController {
    let newsService = NewsService()
    var news: [News] = [] // Массив новостей
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загрузка новостей из API
        fetchNews()
        
      
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
    }
    func fetchNews() {
            newsService.fetchNews { [weak self] (news) in
                self?.news = news

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
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
