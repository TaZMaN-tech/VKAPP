//
//  AuthorAndDate{ost.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 08.02.2022.
//

import UIKit

class AuthorCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
    
    func configure(item: News) {
        authorImageView.image = UIImage.loadAvatar(item.avatarURL ?? "")
        authorLabel.text = item.creatorName
        dateLabel.text = String(item.date)
    }
}
