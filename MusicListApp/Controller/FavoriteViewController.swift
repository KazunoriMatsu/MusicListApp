//
//  FavoriteViewController.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/04/08.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import AVFoundation
//音を鳴らす
import PKHUD


class PlayMusicButton:UIButton{
    
    var params:Dictionary<String,Any>
    override init(frame:CGRect){
        self.params = [:]
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder:NSCoder) {
        
        self.params = [:]
        super.init(coder: aDecoder)
        
    }
    
}

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,URLSessionDownloadDelegate {
    
    
    
    @IBOutlet weak var favTableView: UITableView!
    
    var musicDataModelArray = [MusicDataModel]()
    var artworkUrl = ""
    var previewUrl = ""
    var artistName = ""
    var trackCensordName = ""
    //music name のこと
    //Jsonデータで引っ張ってくる時こういうキー値で保存されているからこういう変数名で作る
    var userID = ""
    var favRef = Database.database().reference()
    //初期化
    var userName = ""
    
    var player:AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTableView.allowsSelection = true
        
        if UserDefaults.standard.object(forKey: "userID") != nil{
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            
            userID = UserDefaults.standard.object(forKey: "userName") as! String
            self.title = "\(userName)'s MusicList"
        }
        
        
        favTableView.delegate = self
        favTableView.dataSource = self
        //セルの選択可能
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
//        self.navigationController?.navigationBar.tintColor = .white
        
        self.title = "\(userName)'s MusicList"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.progress)
        //インディケーターを回す
        favRef.child("users").child(userID).observe(.value){
            (snapshot) in
            
            self.musicDataModelArray.removeAll()
            //次検索したい時に、MusicDataModelに値が残らないように
            
            for child in snapshot.children{
                
                let childSnapshot = child as! DataSnapshot
                let musicData = MusicDataModel(snapshot: childSnapshot)
                self.musicDataModelArray.insert(musicData, at: 0)
                self.favTableView.reloadData()
            }
            
            
             //値を取得する　⇨ usersのじ自分のIDの下にあるお気に入りにしたコンテンツ全て
            
            HUD.hide()
            //とってきた後にインディケーターを消す
        }
       
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicDataModelArray.count
        //セルの数
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
        //高さ
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //セクションの数
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //funcのtableViewだからfavTableViewではない
        
        let musicDataModel = musicDataModelArray[indexPath.row]
        //musicDataModelArrayのrow番目をインクリメントする
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let label1 = cell.contentView.viewWithTag(2) as! UILabel
        let label2 = cell.contentView.viewWithTag(3) as! UILabel
        label1.text = musicDataModel.artistName
        label2.text = musicDataModel.musicName
        
        imageView.sd_setImage(with: URL(string: musicDataModel.imageString), placeholderImage: UIImage(named: "noimage"), options: .continueInBackground, context: nil, progress: nil, completed: nil)
        
        
        let playButton = PlayMusicButton(frame: CGRect(x: view.frame.size.width - 60, y: 50, width: 60, height: 60))
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTap(_ :)), for: .touchUpInside)
        playButton.params["value"] = indexPath.row
        cell.accessoryView = playButton
        
        //再生ボタン
        
        
        return cell
        
    }
    
    @objc func playButtonTap(_ sender:PlayMusicButton){
        if player?.isPlaying == true{
            
        player!.stop()
        //音楽を一旦止める
        }
        
        let indexNumber:Int = sender.params["value"] as! Int
        //senderは押されたボタンの事
        let urlString = musicDataModelArray[indexNumber].previewURL
        let url = URL(string: urlString!)
        
        print(url!)
        
        downloadMusicURL(url: url!)
       //ダウンロード
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        if player?.isPlaying == true{
            
        player!.stop()
        //音楽を一旦止める
        }
     
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func downloadMusicURL(url:URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            self.play(url: url!)
            //再生
            
        })
        
        downloadTask.resume()
        //ダウンロードされるまでここ
        
    }
    
    
    func play(url:URL){
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            //再生準備
            player?.volume = 1.0
            player?.play()
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Done")
        //ダウンロードが終わった後に呼ばれる箇所
        
    }

}
