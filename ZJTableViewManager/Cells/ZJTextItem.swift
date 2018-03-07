//
//  ZJTextItem.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

class ZJTextItem: ZJTableViewItem {
    var text: String?
    var placeHolder: String?
    var didChanged: ZJTableViewItemBlock?
    override init() {
        super.init()
        self.cellHeight = 125
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    convenience init(text: String?, placeHolder: String, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.text = text
        self.placeHolder =  placeHolder
        self.didChanged = didChanged
    }
}
