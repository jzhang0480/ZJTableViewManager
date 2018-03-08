//
//  ZJTextFieldItem.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

open class ZJTextFieldItem: ZJTableViewItem {
    public var title: String?
    public var placeHolder: String?
    public var text: String?
    public var didChanged: ZJTableViewItemBlock?
    public var isFullLength: Bool = false
    public var isSecureTextEntry: Bool = false
    
    convenience public init(title: String?, placeHolder: String?, text: String?,isFullLength: Bool = false, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.title = title
        self.placeHolder = placeHolder
        self.text = text
        self.isFullLength = isFullLength
        self.didChanged = didChanged
    }
}

