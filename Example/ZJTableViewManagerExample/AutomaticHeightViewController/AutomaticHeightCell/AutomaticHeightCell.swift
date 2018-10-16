//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit

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
    
    override func cellWillAppear() {
        let item = self.item as! AutomaticHeightCellItem
        configWithItem(item: item)
    }
    
    /// 把赋值的代码写在这个方法里面（会在动态高度方法里面调用，注意这里面不能调用cell的item属性，因为计算高度的时候cell的item属性还没有被赋值）
    func configWithItem(item: AutomaticHeightCellItem) {
        labelTitle.text = item.title
        labelContent.text = item.content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
