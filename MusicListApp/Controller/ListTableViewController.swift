//
//  ListTableViewController.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/04/12.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth
import PKHUD

class ListTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listRef = Database.database().reference()
    //レファレンス
    var indexNumber = Int()
    var getUserIDModelArray = [GetUserIDModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        HUD.show(.success)
        //コンテンツを取得する
        //swift life cycle検索
        
        listRef.child("profile").observe(.value) { (snapshot) in
            HUD.hide()
            
            self.getUserIDModelArray.removeAll()
            
            for child in snapshot.children{
                //snapshot.childrenはprofileの下のオートID達
                
                let childSnapshot = child as! DataSnapshot
                let listData = GetUserIDModel(snapshot: childSnapshot)
                self.getUserIDModelArray.insert(listData,at: 0)
                self.tableView.reloadData()
                
                
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUserIDModelArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        
        cell.selectionStyle = .none
        
        let listDataModel = getUserIDModelArray[indexPath.row]
        let userNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        userNameLabel.text = "`\(String(describing: listDataModel.userName!))'s List"

        //アンラップ
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //userIDと名前を渡して、渡されたConntrollerでIDからusers.idで全部取得して、userNameのListとして表示させる準備
        
        let otherVC = self.storyboard?.instantiateViewController(identifier:"otherList") as! OtherPersonListViewController
        
        let listDataModel = getUserIDModelArray[indexPath.row]
        //selectされた場所
        //配列に入っているものをlistDataModelに入れる
        
        otherVC.userName = listDataModel.userName
        otherVC.userID = listDataModel.userID
        
        self.navigationController?.pushViewController(otherVC, animated: true)
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
