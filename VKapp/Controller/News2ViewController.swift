//
//  News2ViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 09.02.2022.
//

import UIKit

class News2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let news = News.fake
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = news[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
            if !item.photos.isEmpty {
                cell.configure(item: item)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            
            cell.configure(item: item)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath) as! AuthorCell
            
            cell.configure(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesAndCommentsCell", for: indexPath) as! LikesAndCommentsCell
            
//            cell.configure(item: news[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        view.backgroundColor = .lightGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 10, height: 60))
        label.text = news[section].newsTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        
        view.addSubview(label)
        return view
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        news[section].newsTitle
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 350
        } else if indexPath.row == 1 {
            return 100
        } else if indexPath.row == 2 {
            return 60
        } else {
            return UITableView.automaticDimension
        }
    }


}
