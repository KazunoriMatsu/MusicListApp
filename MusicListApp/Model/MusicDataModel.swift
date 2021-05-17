//
//  MusicDataModel.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/03/28.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import Foundation
import Firebase
import PKHUD


class MusicDataModel {
    var artistName:String! = ""
    var musicName:String! = ""
    var previewURL:String! = ""
    var imageString:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    var artistViewURL:String! = ""
    let ref:DatabaseReference!
    
    var key:String! = ""
    
    init(artistName:String, musicName:String!, previewURL:String!, imageString:String!, userID:String!, userName:String!){
        
        self.artistName = artistName
        self.musicName = musicName
        self.previewURL = previewURL
        self.imageString = imageString
        self.userID = userID
        self.userName = userName
        
        ref = Database.database().reference().child("users").child(userID).childByAutoId()
        //ログイン時に拾えるuidを先頭につけて送信、受信する時もuidから引っ張ってくる
        
    }
    
    init(snapshot:DataSnapshot){
        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any]{
            artistName = value["artistName"] as? String
            musicName = value["musicName"] as? String
            imageString = value["imageString"] as? String
            previewURL = value["previewURL"] as? String
            userID = value["userID"] as? String
            userName = value["userName"] as? String
            //受信でき、自分のプロパティに入れて表示していく
        }
    }
    
    func toContents() -> [String:Any] {
        return ["artistName":artistName!, "musicName":musicName!, "previewURL":previewURL!, "imageString":imageString!, "userID":userID!, "userName":userName!]
        //firebaseに突っ込む時のこと ディクショナリー型
    }
    
    func save(){
        ref.setValue(toContents())
        //refは(35行目あたり)usersの中の外部から入ってきたuserIDのchildByAutoIdの箇所に上記func内のreturnを入れる
    }
    
}
