//
//  ZJCell.swift
//  ZJTableViewManager
//
//  Created by Jie Zhang on 2022/12/13.
//

import UIKit

open class ZJBaseCell: UITableViewCell {
    var _item: ZJItem!
}

open class ZJCell<T: ZJItem>: ZJBaseCell {
    public var item: T {
        get {
            return _item as! T
        }
        set {
            _item = newValue
        }
    }
}
