//
//  NewsViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 17.12.2021.
//

import UIKit

final class NewsViewController: UITableViewController {

//    let news = News.fake
    
    lazy var service = VKAPI()
    
//    override func viewDidLoad() {
//        service.getNews(comletionHandler: <#T##([News]) -> Void#>)
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        news.count
//    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        
//        cell.configure(item: news[indexPath.row])
        return cell
    }

}
