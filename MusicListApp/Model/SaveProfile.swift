//
//  SaveProfile.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/03/19.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import Foundation
import Firebase
import PKHUD
//くるくる

class SaveProfile {
    
    //サーバーに値を飛ばす
    
    var userID:String! = ""
    var userName:String! = ""
    var ref :DatabaseReference!
    
    init(userID:String, userName:String){
        
        self.userID = userID
        self.userName = userName
        
        //ログインの時に拾えるuidを先頭につけて送信する。受信する時もuidから引っ張ってくる
        
        ref = Database.database().reference().child("profile").childByAutoId()
        
    }
    
    init(snapShot:DataSnapshot){
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any]{
            userID = value["userID"] as? String
            userName = value["userName"] as? String
        }
    }
    
    func toContents()->[String:Any]{
        
        return ["userID":userID!, "userName":userName as Any]
//        "userID":self.userID でも可
        
    }
    func saveProfile(){
        ref.setValue(toContents())
        UserDefaults.standard.set(ref.key, forKey: "autoID")
    }
}
