//
//  CardViewCell.swift
//  MusicListApp
//
//  Created by 松原和紀 on 2021/03/28.
//  Copyright © 2021 Kazunori Matsubara. All rights reserved.
//

import UIKit
import VerticalCardSwiper
//親クラスにCardCellを持てるようのにするため

class CardViewCell: CardCell {
    
    @IBOutlet weak var artworkImageView:UIImageView!
    @IBOutlet weak var musicNameLabel:UILabel!
    @IBOutlet weak var ArtistNameLabel:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func setRandomBackgroundColor() {
        let randomRed: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        //カードはスワイプするごとにランダムで背景色を決められるようにする為のライブラリ
    }

    
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        //セルの角丸
        super.layoutSubviews()
    }

    
    
}
