//
//  NewsTextCell.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 08.02.2022.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    @IBOutlet weak var newsTextLabel: UILabel!
    
    func configure(item: News) {
        newsTextLabel.text = item.text
    }
}
