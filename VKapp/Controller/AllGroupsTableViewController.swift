//
//  AllGroupsTableViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 22.11.2021.
//

import UIKit
import RealmSwift

class AllGroupsTableViewController: UITableViewController {

    lazy var service = VKAPI()
    var groups: Results<Group>!
    
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadsGroupsFromRealm()
        setupGroups()
        subscribeToNotification()
        
    }
    
    //MARK: - Setup
    
    private func subscribeToNotification() {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "")
            notificationToken = realm.objects(User.self).observe { (changes) in
                switch changes {
                case .initial:
                    break
                case let .update(_, deletions, insertions, modifications):
                    self.tableView.reloadData()
                case .error(let error):
                    print(error)
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    func loadsGroupsFromRealm() {
        do {
            let realm = try Realm()
            let items = realm.objects(Group.self)
            self.groups = items
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    private func setupGroups() {
        self.loadsGroupsFromRealm()
        service.getGroups() { _ in
            self.loadsGroupsFromRealm()
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! FriendTableViewCell

        let group = groups[indexPath.row]
//        let image = UIImage(named: group.groupImage)
        cell.friendTittleLabel?.text = group.name
//        cell.avatarView.image = image?.resizeWithScaleAspectFitMode(to: 50)
        if let url = URL(string: group.groupImage) {
            cell.avatarView.imageView.loadAvatar(url: url)
        }


        return cell
    }

}
