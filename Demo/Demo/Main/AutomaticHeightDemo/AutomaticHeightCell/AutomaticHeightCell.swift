//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class AutomaticHeightCellItem: ZJItem , ZJItemable {
    static var cellClass: ZJBaseCell.Type { AutomaticHeightCell.self }
    var feed: Feed!
}

class AutomaticHeightCell: ZJCell<AutomaticHeightCellItem>, ZJCellable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// cell即将出现在屏幕中的回调方法 在这个方法里面赋值
    func cellPrepared() {
        titleLabel.text = item.feed.title
        contentLabel.text = item.feed.content
        if item.feed.imageName.isEmpty == false {
            contentImageView.isHidden = false
            contentImageView.image = UIImage(named: item.feed.imageName)
        } else {
            contentImageView.isHidden = true
        }
        
        usernameLabel.text = item.feed.username
        timeLabel.text = item.feed.time
    }
}
