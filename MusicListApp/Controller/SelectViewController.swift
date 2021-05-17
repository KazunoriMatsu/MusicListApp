//
//  SelectViewController.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/03/27.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import UIKit
import VerticalCardSwiper
//tinderのようなカード画面
import SDWebImage
//データベースから画像のURLをとってきて表示するときにキャッシュを取れる
import PKHUD
//くるくる(インディケーター)
import Firebase
//右にスワイプした時にデータベースに飛ばす
import ChameleonFramework
//色を司る

class SelectViewController: UIViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource{
    
    
    
    //受け取り用
    //parseがを終わった後に流れてくるもの
    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    
    var indexNumber = Int()
    var userID = String()
    var userName = String()
    
    //右にスワイプした時に好きなものを入れる配列
    var likeArtistNameArray = [String]()
    var likeMusicNameArray = [String]()
    var likePreviewURLArray = [String]()
    var likeImageStringArray = [String]()
    var likeArtistViewArray = [String]()
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        cardSwiper.register(nib:UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: "CardViewCell")
        
        cardSwiper.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return artistNameArray.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: index) as? CardViewCell {
            verticalCardSwiperView.backgroundColor = UIColor.randomFlat()
            //cardの後ろのカラーもランダムにする為、flatを使う。カメレオン。
            view.backgroundColor = verticalCardSwiperView.backgroundColor
            
            let artistName = artistNameArray[index]
            let musicName = musicNameArray[index]
            //numberOfCardsの数だけcardForItemAtが呼ばれる。indexが自動的にインクリメントされる。
            cardCell.setRandomBackgroundColor()
            cardCell.ArtistNameLabel.text = artistName
            cardCell.ArtistNameLabel.textColor = UIColor.white
            cardCell.musicNameLabel.text = musicName
            cardCell.musicNameLabel.textColor = UIColor.white
            
            cardCell.artworkImageView.sd_setImage(with: URL(string: imageStringArray[index]), completed: nil)
            return cardCell
            
            //セル(カード)に配列を表示させる
        }
        
        return CardCell()
        //caedcellがない場合は空のcardcellを返す処理。有無の確認
        
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        indexNumber = index
        if swipeDirection == .Right {
            likeArtistNameArray.append(artistNameArray[indexNumber])
            likeMusicNameArray.append(musicNameArray[indexNumber])
            likePreviewURLArray.append(previewURLArray[indexNumber])
            likeImageStringArray.append(imageStringArray[indexNumber])

            if likeArtistNameArray.count != 0 && likeMusicNameArray.count != 0 && likePreviewURLArray.count != 0 && likeImageStringArray.count != 0 {

                let musicDataModel = MusicDataModel(artistName: artistNameArray[indexNumber], musicName: musicNameArray[indexNumber], previewURL: previewURLArray[indexNumber], imageString: imageStringArray[indexNumber], userID: userID, userName: userName)
                
                musicDataModel.save()
            }
        }

        
        // called right before the card animates off the screen.
        artistNameArray.remove(at: index)
        musicNameArray.remove(at: index)
        previewURLArray.remove(at: index)
        imageStringArray.remove(at: index)
        
        //swipe後配列の中から消す
        //値が残ったままだとインデックスが崩れる
    }
    
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
        indexNumber = index
        //何番目がスワイプされたかを検知しindexNumberに入れる
        
        if swipeDirection == .Right{
            //右にスワイプした時に呼ばれる箇所
            
            likeArtistNameArray.append(artistNameArray[indexNumber])
            likeMusicNameArray.append(musicNameArray[indexNumber])
            likePreviewURLArray.append(previewURLArray[indexNumber])
            likeImageStringArray.append(imageStringArray[indexNumber])
            //右にスワイプした時に好きなものとして、新しい配列に入れてあげる
            if likeArtistNameArray.count != 0 && likeMusicNameArray.count != 0 && likePreviewURLArray.count != 0 && likePreviewURLArray.count != 0 {
                
                let musicDataModel = MusicDataModel(artistName: artistNameArray[indexNumber], musicName: musicNameArray[indexNumber], previewURL: previewURLArray[indexNumber], imageString: imageStringArray[indexNumber], userID: userID, userName: userName)
                //userID, userNameは33,34行目で持ってる
                musicDataModel.save()
                //firebaseに飛ばす
                
            }
            
            //上記の配列が０でない場合、firebase内に値を好きなものとして保存する処理をMusicDataModelにて行なう
            
        }
        
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //戻るボタン
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
