//
//  AvatarView.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 06.12.2021.
//

import UIKit

@IBDesignable
class AvatarImage: UIView {

    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = .black {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.5 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            imageView.image = image
            setNeedsDisplay()
        }
    }
    
    //MARK: - Subviews
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(shadowView)
        addSubview(imageView)
        
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        shadowView.layer.cornerRadius = shadowView.frame.width / 2
    }
    
    private func updateShadow() {
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
    }
    
    @objc private func viewTapped(sender: UIGestureRecognizer) {
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3 )
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.transform = .identity
                       },
                       completion: nil
         )
    }
}
