//
//  GalleryViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    enum Direction {
        case left, right
        
        init (x: CGFloat) {
            self = x > 0 ? .right : .left
        }
    }
    
    var photos: [String] = [] {
        didSet {
            self.images = photos.compactMap {UIImage.loadAvatar($0) }
        }
    }
    var images: [UIImage] = []
    var currentIndex = 0
    
    @IBOutlet weak var imageView: UIImageView!
    lazy var nextImageView = UIImageView()
    
    private var animator: UIViewPropertyAnimator!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit
        
        imageView.image = images[currentIndex]
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        
        view.addGestureRecognizer(pan)
    }
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard let panView = recognizer.view else { return }
        
        let translation = recognizer.translation(in: panView)
        let direction = Direction(x: translation.x)
        
        switch recognizer.state {
        
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.imageView.alpha = 0
            })
            if canSlide(direction) {
                let nextIndex = direction == .left ? currentIndex + 1 : currentIndex - 1
                nextImageView.image = images[nextIndex]
                view.addSubview(nextImageView)
                let offsetX = direction == .left ? view.bounds.width : -view.bounds.width
                nextImageView.frame = view.bounds.offsetBy(dx: offsetX, dy: 0)
                
                animator.addAnimations({self.nextImageView.center = self.imageView.center
                }, delayFactor: 0.2)
            }
            
            animator.addCompletion { (position) in
                guard position == .end else { return }
                self.currentIndex = direction == .left ? self.currentIndex + 1 : self.currentIndex - 1
                self.imageView.alpha = 1
                self.imageView.transform = .identity
                self.imageView.image = self.images[self.currentIndex]
                self.nextImageView.removeFromSuperview()
                
            }
            animator.pauseAnimation()
            
        case .changed:
            let relativeTranslation = abs(translation.x) / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            animator.fractionComplete = progress
            
        case .ended:
            if canSlide(direction), animator.fractionComplete > 0.6 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = .identity
                    self.imageView.alpha = 1
                    let offsetX = direction == .left ? self.view.bounds.width : -self.view.bounds.width
                    self.nextImageView.frame = self.view.bounds.offsetBy(dx: offsetX, dy: 0)
                    self.nextImageView.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    private func canSlide(_ direction:Direction) -> Bool {
        if direction == .left {
            return currentIndex < images.count - 1
        } else {
            return currentIndex > 0
        }
    }
    
}
