//
//  FriendCollectionViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 03.12.2021.
//

import UIKit


class FriendCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: UICollectionViewDataSource
    
    private enum Constants {
        static let padding: CGFloat = 5
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        photos.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendCollectionViewCell
        let photo = photos[indexPath.row]
        
        if let url = URL(string: photo) {
            cell.friendImage.loadAvatar(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - Constants.padding) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.padding
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let controller = segue.destination as? GalleryViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first
            else { return }
        
        controller.title = title
        controller.photos = photos
        controller.currentIndex = indexPath.row
    }

    
}
