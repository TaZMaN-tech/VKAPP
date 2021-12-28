//
//  FriendsTableViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 15.11.2021.
//

import UIKit
import Fakery

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LetterPickerDelegate, UISearchBarDelegate {
    
    let service = VKAPI()
    
//    let friends = User.randomMany.sorted { $0.fullName.lowercased() < $1.fullName.lowercased() }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeader")
        
        setupAllFriends()
        reloadDataSource()
        setupViews()
        
    }
    
    
    //MARK: - Setup
    
    private func setupAllFriends() {
        allFriends = User.randomMany.sorted { $0.fullName.lowercased() < $1.fullName.lowercased() }
    }
    
    private func reloadDataSource() {
        filterFriends(text: searchBar.text)
        
        let allLetters = filteredFriends.map { $0.lastName.uppercased().prefix(1) }
        sections = Array(Set(allLetters)).sorted().map {String($0)}
        
        cashedSectionFriends = [:]
    }
    
    private func setupViews() {
        letterPicker.delegate = self
        letterPicker.letters = sections
    }
    //MARK: -  Data Source
    
    var sections: [String] = []
    var allFriends: [User] = []
    var filteredFriends: [User] = []

    var cashedSectionFriends: [String: [User]] = [:]
    
    func getFriends(for section: Int) -> [User] {
        let sectionLetter = sections[section]
        
        if let sectionFriends = cashedSectionFriends[sectionLetter] {
            return sectionFriends
        }
        
        let sectionFriends = filteredFriends.filter {
            $0.lastName.uppercased().prefix(1) == sectionLetter
        }
        cashedSectionFriends[sectionLetter] = sectionFriends
        return sectionFriends
    }
    
    func getFriend(for indexPath: IndexPath) -> User {
        getFriends(for: indexPath.section)[indexPath.row]
    }
    
    func filterFriends(text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredFriends = allFriends
            return
        }
        
        filteredFriends = allFriends.filter { $0.fullName.lowercased().contains(text.lowercased()) }

    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendCollectionViewController,
        let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let friend = getFriend(for: indexPath)
        controller.photos = friend.photos
        controller.title = friend.fullName 
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getFriends(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        let friend = getFriend(for: indexPath)
        cell.friendTittleLabel?.text = friend.fullName
        let image = UIImage.loadAvatar(friend.avatar)
        cell.avatarView.imageView.image = image?.resizeWithScaleAspectFitMode(to: 50)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as? CustomHeader else { return nil}
        headerView.label.text = sections[section]
        
        return headerView
    }
    
    //MARK: - LetterPickerDelegate
    
    func letterPicked(_ letter: String) {
        guard let sectionIndex = sections.firstIndex(where: { $0 == letter }) else { return }
        
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadDataSource()
        tableView.reloadData()
        letterPicker.letters = sections
    }

}
