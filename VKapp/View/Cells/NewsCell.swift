//
//  NewsCell.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 17.12.2021.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var photosContainer: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
    
    func configure(item: News) {
        authorImageView.image = UIImage.loadAvatar(item.author.avatar)
        authorLabel.text = item.author.fullName
        dateLabel.text = item.postDate
        newsTextLabel.text = item.text 
        setupPhotos(item.photos)
    }
    
    private func setupPhotos(_ photos: [String]) {
        photosContainer.isHidden = photos.count == 0
        guard !photos.isEmpty else {
            return
        }
        
        photosContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        switch photos.count {
        case 1:
            let imageView = createImageView(photos[0])
            photosContainer.addSubview(imageView)
            pinView(imageView, to: photosContainer)
        case 2:
            let leftImageView = createImageView(photos[0])
            let rightImageView = createImageView(photos[1])
            let stackView = UIStackView(arrangedSubviews: [leftImageView, rightImageView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal

            photosContainer.addSubview(stackView)
            pinView(stackView, to: photosContainer)

            NSLayoutConstraint.activate([
                leftImageView.widthAnchor.constraint(equalTo: rightImageView.widthAnchor)
            ])
        case 3:
            let topLeftImageView = createImageView(photos[0])
            let topRightImageView = createImageView(photos[1])
            let topStackView = UIStackView(arrangedSubviews: [topLeftImageView, topRightImageView])
            topStackView.translatesAutoresizingMaskIntoConstraints = false
            topStackView.axis = .horizontal

            let bottomImageView = createImageView(photos[2])
            let bottomStackView = UIStackView(arrangedSubviews: [topStackView, bottomImageView])
            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            bottomStackView.axis = .horizontal

            let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical

            photosContainer.addSubview(stackView)
            pinView(stackView, to: photosContainer)

            NSLayoutConstraint.activate([
                topLeftImageView.widthAnchor.constraint(equalTo: topRightImageView.widthAnchor),
                topStackView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor),
            ])
        default:
            let topLeftImageView = createImageView(photos[0])
            let topRightImageView = createImageView(photos[1])
            let topStackView = UIStackView(arrangedSubviews: [topLeftImageView, topRightImageView])
            topStackView.translatesAutoresizingMaskIntoConstraints = false
            topStackView.axis = .horizontal
            
            let bottomLeftImageView = createImageView(photos[2])
            let bottomRightImageView = createImageView(photos[3])
            let bottomStackView = UIStackView(arrangedSubviews: [bottomLeftImageView, bottomRightImageView])
            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            bottomStackView.axis = .horizontal
            
            let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            
            photosContainer.addSubview(stackView)
            pinView(stackView, to: photosContainer)
            
            NSLayoutConstraint.activate([
                topLeftImageView.widthAnchor.constraint(equalTo: topRightImageView.widthAnchor),
                bottomLeftImageView.widthAnchor.constraint(equalTo: bottomRightImageView.widthAnchor),
                topStackView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor),
            ])
            
            let limit = 4
            if photos.count > limit {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "+\(photos.count - limit)"
                label.textColor = .white
                label.font = .systemFont(ofSize: 80)
                
                bottomRightImageView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerYAnchor.constraint(equalTo: bottomRightImageView.centerYAnchor),
                    label.centerXAnchor.constraint(equalTo: bottomRightImageView.centerXAnchor)
                ])
            }
        }
    }
    
    private func createImageView(_ photo:String) -> UIImageView {
        let imageView = UIImageView(image: UIImage.loadAvatar(photo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func pinView(_ view:UIView, to otherView: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: otherView.topAnchor),
            view.bottomAnchor.constraint(equalTo: otherView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: otherView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: otherView.trailingAnchor)
        ])
    }
    
}
