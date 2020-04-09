//
//  CardTableViewCell.swift
//  ZJTableViewManagerExample
//
//  Created by Jie Zhang on 2019/8/15.
//  Copyright © 2019 上海勾芒信息科技. All rights reserved.
//

import UIKit
let openHeight: CGFloat = (UIScreen.main.bounds.size.width - 30) * (593 / 939) + 25
let closeHeight: CGFloat = 54
class CardTableViewCellItem: ZJTableViewItem {
    var isOpen = false
    var zPosition: CGFloat = 0
    override init() {
        super.init()
        cellHeight = closeHeight
        selectionStyle = .none
    }

    func openCard() {
        isOpen = true
        cellHeight = openHeight
    }

    func closeCard() {
        isOpen = false
        cellHeight = closeHeight
    }
}

class CardTableViewCell: ZJTableViewCell {
    @IBOutlet var cardView: UIView!
    @IBOutlet var cardImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radius: CGFloat = 15
        cardView.layer.cornerRadius = radius
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cardView.layer.shadowRadius = radius
        cardImg.layer.cornerRadius = radius
        cardImg.clipsToBounds = true
    }

    override func cellWillAppear() {
        let item = self.item as! CardTableViewCellItem
        layer.zPosition = item.zPosition
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
