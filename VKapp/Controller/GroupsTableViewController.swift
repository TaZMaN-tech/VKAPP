//
//  GroupsTableViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 15.11.2021.
//

import UIKit
import Firebase


class GroupsTableViewController: UITableViewController {
    
    let MY_GROUPS = "MyGroups"
    
    
    lazy var service = VKAPI()
    
    var myGroups: [Group] = []
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroupsFromFirestore()
        
//        setupGroups()
    }
    
    //MARK: - Setup
    
    private func setupGroups() {
        service.getGroups() { groups in
            self.myGroups = groups
            self.tableView.reloadData()
        }
    }
    
    private func setupGroupsFromFirestore() {
        db.collection(MY_GROUPS).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                  //  self.myGroups.append(document.data())
                    let doc = document.data()
                    let group = Group()
                    group.id = doc["id"] as? Int ?? 0
                    group.name = doc["name"] as? String ?? ""
                    group.groupImage = doc["groupImage"] as? String ?? ""
                    print(group)
                    self.myGroups.append(group)
//                    print("\(document.documentID) => \(document.data())")
                }
            }
            self.tableView.reloadData()
        }        
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
//        let image = UIImage(named: group.groupImage)
        cell.friendTittleLabel?.text = group.name
//        cell.avatarView.image = image?.resizeWithScaleAspectFitMode(to: 50)
         if let url = URL(string: group.groupImage) {
            cell.avatarView.imageView.loadAvatar(url: url)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = myGroups[indexPath.row].id
            myGroups.remove(at: indexPath.row)
            
            db.collection(MY_GROUPS).whereField("id", isEqualTo: id).getDocuments() { (querySnapshot, err) in
                for doc in querySnapshot?.documents ?? [QueryDocumentSnapshot]() {
                    doc.reference.delete()
                }
            }
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
        ref = db.collection(MY_GROUPS).addDocument(data: [
            "name": group.name,
            "groupImage": group.groupImage,
            "id": group.id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        tableView.reloadData()
    
    }
}
