//
//  GroupsTableViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 15.11.2021.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var myGroups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupCell", for: indexPath) as! FriendTableViewCell

        let group = myGroups[indexPath.row]
        let image = UIImage(named: group.groupImage)
        cell.friendTittleLabel.text = group.name
        cell.avatarView.image = image?.resizeWithScaleAspectFitMode(to: 50)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - Segues
    
    @IBAction func unwindFromAllGroups(_ sender: UIStoryboardSegue) {
        guard
            let allGroupsVC = sender.source as? AllGroupsTableViewController,
            let indexPath = allGroupsVC.tableView.indexPathForSelectedRow
            else { return }
        
        let group = allGroupsVC.groups[indexPath.row]
        if myGroups.contains(where: { gr in
            group.name == gr.name
        }) {
            return
        }
        myGroups.append(group)
        tableView.reloadData()
    }
    
   
}
