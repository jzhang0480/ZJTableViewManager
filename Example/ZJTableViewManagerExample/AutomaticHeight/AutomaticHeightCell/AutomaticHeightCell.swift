//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit
import ZJTableViewManager
class AutomaticHeightCellItem: ZJTableViewItem {
    var title: String!
    var content: String!
    
}

/// 动态高度的cell说明：支持系统autolayout搭建的cell（xib以及snapkit等基于autolayout的约束框架理论上都是支持的）
class AutomaticHeightCell: ZJTableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// cell即将出现在屏幕中的回调方法 在这个方法里面赋值
    override func cellWillAppear() {
        let item = self.item as! AutomaticHeightCellItem
        labelTitle.text = item.title
        labelContent.text = item.content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
