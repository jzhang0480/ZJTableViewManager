//
//  ZJTextItem.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

open class ZJTextItem: ZJTableViewItem {
    public var text: String?
    public var placeHolder: String?
    public var textViewBackgroundColor: UIColor = UIColor.white
    public var didChanged: ZJTableViewItemBlock?
    override init() {
        super.init()
        self.cellHeight = 125
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    convenience public init(text: String?, placeHolder: String, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.text = text
        self.placeHolder =  placeHolder
        self.didChanged = didChanged
    }
}

