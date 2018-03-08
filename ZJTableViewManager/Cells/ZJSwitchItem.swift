//
//  ZJSwitchItem.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

public class ZJSwitchItem: ZJTableViewItem {
    public var title: String?
    public var isOn: Bool = false
    public var didChanged: ZJTableViewItemBlock?
    convenience public init(title: String?, isOn: Bool, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.title = title
        self.isOn = isOn
        self.didChanged = didChanged
    }
}

