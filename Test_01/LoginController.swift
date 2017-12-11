//
//  ViewController.swift
//  Test_01
//
//  Created by Jithin Paul on 2017-12-08.
//  Copyright © 2017 Jithin Paul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseDatabaseUI

class LoginController: UIViewController,UITextViewDelegate, FUIAuthDelegate {
    var dbRef: DatabaseReference?
    var dbHandler: DatabaseHandle?
    
    @IBOutlet weak var gpsTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!

    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil{
            print("----Not authenticated")
            login();
        }
        else{
            print("-----AUTHENTICATED")
            //performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bioTextView.delegate = self
        checkLoggedIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLoggedIn(){
        dbRef = Database.database().reference().child("users")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                self.dbHandler = self.dbRef?.child((user?.uid)!).observe(DataEventType.value, with: {(snapshot) in
                    print("-------- Data Changed")
                    guard snapshot.exists() else{
                        print("--User doesn't exist")
                        return
                    }
                    let dataChanged = snapshot.value as! [String:String]
                    
                    if let username = dataChanged["username"]{
                        self.usernameTextField.text = username
                        print("----- username changed " + username)
                    }
                    
                    if let bio = dataChanged["bio"]{
                        self.bioTextView.text = bio
                        print("----- bio changed " + bio)
                    }
                    
                    if let gps = dataChanged["gps"]{
                        self.gpsTextField.text = gps
                        print("----- gps changed " + gps)
                    }
                    
                })
                print("---Already logged in")
            }
            else{
                self.login()
            }
        }
    }
    
    
    @IBAction func usernameEdit(_ sender: UITextField) {
        print("------- Inside usernameEdit")
        if let uid:String = (Auth.auth().currentUser?.uid){
            dbRef?.child("\(uid)/username").setValue(sender.text)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        print("------- Inside bioEdit")
        if let uid:String = (Auth.auth().currentUser?.uid){
            dbRef?.child("\(uid)/bio").setValue(textView.text)
        }
        return true;
    }
    
    @IBAction func gpsEdit(_ sender: UITextField) {
        print("------- Inside gpsEdit")
        if let uid:String = (Auth.auth().currentUser?.uid){
            dbRef?.child("\(uid)/gps").setValue(sender.text)
        }
    }
    
    func login(){
        let authUI = FUIAuth.defaultAuthUI()
        let facebookProvider = FUIFacebookAuth()
        let googleProvider = FUIGoogleAuth()
        authUI?.delegate = self;
        authUI?.providers = [googleProvider,facebookProvider]
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
        print("----Loded login page")
    }
    
    func logout(){
        try! Auth.auth().signOut()
    }
    
    @IBAction func logoutClick() {
        usernameTextField.text = ""
        bioTextView.text = ""
        gpsTextField.text = ""
        self.logout()
    }
    
}


