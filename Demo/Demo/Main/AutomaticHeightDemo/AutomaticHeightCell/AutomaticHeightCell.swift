//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class AutomaticHeightCellItem: ZJTableViewItem {
    var feed: Feed!
}

/// 支持系统autolayout搭建的cell（xib以及snapkit等基于autolayout的约束框架都是支持的）
class AutomaticHeightCell: UITableViewCell, ZJCellProtocol {
    var item: AutomaticHeightCellItem!

    typealias ZJCellItemClass = AutomaticHeightCellItem
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
        contentImageView.image = UIImage(named: item.feed.imageName)
        usernameLabel.text = item.feed.username
        timeLabel.text = item.feed.time
    }
}
