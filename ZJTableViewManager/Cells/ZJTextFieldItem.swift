//
//  ZJTextFieldItem.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class ZJTextFieldItem: ZJTableViewItem {
    var title: String?
    var placeHolder: String?
    var text: String?
    var didChanged: ZJTableViewItemBlock?
    var isFullLength: Bool = false
    var isSecureTextEntry: Bool = false
    
    convenience init(title: String?, placeHolder: String?, text: String?,isFullLength: Bool = false, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.title = title
        self.placeHolder = placeHolder
        self.text = text
        self.isFullLength = isFullLength
        self.didChanged = didChanged
    }
}
