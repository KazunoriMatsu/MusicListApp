//
//  GetUserIDModel.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/04/22.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import Foundation
import Firebase
import PKHUD

class GetUserIDModel {
    
    var userID:String! = ""
    var userName:String! = ""
    var ref:DatabaseReference! = Database.database().reference().child("profile")
    
    init(snapshot:DataSnapshot){
        
        ref = snapshot.ref
        
        if let value = snapshot.value as? [String:Any]{
            
            userID = value["userID"] as? String
            userName = value["userName"] as? String
        }
        
        
    }
    
}
