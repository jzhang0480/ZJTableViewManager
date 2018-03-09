//
//  OrderEvaluateItem.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
import ZJTableViewManager

class OrderEvaluateItem: ZJTableViewItem {
    var title: String?
    var evaluate: String?
    var starValue: CGFloat = 1
    var editable: Bool?
    
    override init() {
        super.init()
        self.cellHeight = 55
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.isHideSeparator = true
    }
    
    convenience init(title: String!, starValue: CGFloat = 1, editable: Bool = true) {
        self.init()
        self.title = title
        self.starValue = starValue
        self.editable = editable
    }
    
}
