//
//  SearchViewController.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/03/19.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON
import DTGradientButton
import FirebaseAuth
import Firebase
import ChameleonFramework


class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var listButton: UIButton!
    
    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    var userID = String()
    var userName = String()
    var autoID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.object(forKey: "autoID") != nil{
            
            autoID = UserDefaults.standard.object(forKey: "autoID") as! String
            print(autoID)
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
//            これをしないと検索窓が見えてしまう
            
            self.present(loginVC, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.object(forKey: "userID") != nil && UserDefaults.standard.object(forKey: "userName") != nil{
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            userName = UserDefaults.standard.object(forKey: "userName") as! String
            //自分のuserIDとuserName
        }

        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        //search画面が出ると同時に検索出す
        
        favButton.setGradientBackgroundColors([UIColor(hex:"E21F70"), UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        
        listButton.setGradientBackgroundColors([UIColor(hex:"FF8960"), UIColor(hex:"FF62A5")], direction: .toBottom, for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //ナビゲーションバーのBackButtonを消す
        //バーの色を設定する
        
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.flatRed()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //バックボタンが消える
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //searchを行う
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func moveToSelectCardView(_ sender: Any) {
        //tinderみたいな動きをする画面に遷移させる
        
        startParse(keyword: searchTextField.text!)
        
        //上記を行うためにパースを行う(json解析)
        
        
    }
    
    func moveToCard(){
        performSegue(withIdentifier: "selectVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchTextField.text != nil && segue.identifier == "selectVC"{
            
            let selectVC = segue.destination as! SelectViewController
            //searchViewController から selectVCに呼び込んでインスタンス化
            selectVC.artistNameArray = self.artistNameArray
            selectVC.imageStringArray = self.imageStringArray
            selectVC.musicNameArray = self.musicNameArray
            selectVC.previewURLArray = self.previewURLArray
            selectVC.userID = self.userID
            selectVC.userName = self.userName
            //値を渡しながら画面遷移する
            
        }
    }
    
    
    func startParse(keyword:String){
        
        HUD.show(.progress)
        
        imageStringArray = [String]()
        previewURLArray = [String]()
        artistNameArray = [String]()
        musicNameArray = [String]()
        
        let urlString = "https://itunes.apple.com/search?turm=\(keyword)&country=jp"
        //keywordはtextFieldのtext
        
        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in
            
            print(response)
            
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                let resultCount:Int = json["resultCount"].int!
                
                for i in 0 ..< resultCount {
                    var artWorkUrl = json["results"][i]["artworkUrl60"].string
                    let previewUrl = json["results"][i]["previewUrl"].string
                    //previewUrlは再生する音源のURLの在処
                    let artistName = json["results"][i]["artistName"].string
                    let trackCensoredName = json["results"][i]["trackCensoredName"].string
                    //trackCensoredNamは曲名
                    
                    if let range = artWorkUrl!.range(of:"60×60bb"){
                        artWorkUrl?.replaceSubrange(range, with: "320×320bb")
                    //artWorkUrlの画像を大きくする処理
                    }
                    
                    self.imageStringArray.append(artWorkUrl!)
                    self.previewURLArray.append(previewUrl!)
                    self.artistNameArray.append(artistName!)
                    self.musicNameArray.append(trackCensoredName!)
                    //取得した値を配列に入れる
                    //!は空を許さない
                    
                    if self.musicNameArray.count == resultCount{
                        self.moveToCard()
                        //クロージャーの中だからselfが必要
                        //カード画面に遷移するfunction
                    }
                    
                }
                HUD .hide()
                // クルクルを閉じる
                
            case .failure(let error):
                print(error)
            }
            
            
        }
        
        //ここに
        
        
    }
    
    
    @IBAction func moveToFav(_ sender: Any) {
        
        let favVC = self.storyboard?.instantiateViewController(identifier: "fav") as! FavoriteViewController
        
        self.navigationController?.pushViewController(favVC, animated: true)
        //画面遷移
    }
    
    
    @IBAction func moveToList(_ sender: Any) {
        let listVC = self.storyboard?.instantiateViewController(identifier: "fav") as! ListTableViewController
        
        self.navigationController?.pushViewController(listVC, animated: true)
        //画面遷移
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
