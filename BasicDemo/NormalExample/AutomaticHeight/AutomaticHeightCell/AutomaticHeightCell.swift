//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit

class AutomaticHeightCellItem: ZJTableViewItem {
    var feed: Feed!
}

/// 支持系统autolayout搭建的cell（xib以及snapkit等基于autolayout的约束框架都是支持的）
class AutomaticHeightCell: UITableViewCell, ZJCellProtocol {
    var item: AutomaticHeightCellItem!
    
    typealias ZJCelltemClass = AutomaticHeightCellItem
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// cell即将出现在屏幕中的回调方法 在这个方法里面赋值
    func cellWillAppear() {
        titleLabel.text = item.feed.title
        contentLabel.text = item.feed.content
        contentImageView.image = UIImage(named: item.feed.imageName)
        usernameLabel.text = item.feed.username
        timeLabel.text = item.feed.time
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
