//
//  UsersTableViewControlle.swift
//  Test_01
//
//  Created by Jithin Paul on 2017-12-10.
//  Copyright © 2017 Jithin Paul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI

class UsersTableViewControlle: UITableViewController {

    var userList = [AppUser]();
    var dbRef:DatabaseReference?
    var dbHandler:DatabaseHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("/users")
        self.getData()
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named:"Image")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    func getData(){
        dbRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            print("------ Getting users from db")
            let data = snapshot.value as! [String:AnyObject]
            print(data)
            self.userList.removeAll()
            
            for (_,userData) in data{
                let newUser = AppUser(userData as! [String:String])
                self.userList.append(newUser)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRow", for: indexPath)
        cell.textLabel!.text = userList[indexPath.row].username
        cell.detailTextLabel!.text = userList[indexPath.row].bio

        return cell
    }

}
