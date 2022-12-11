//
//  ZJSwitchCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class ZJSwitchItem: ZJTableViewItem {
    var title: String?
    var isOn: Bool = false
    var didChanged: ((ZJSwitchItem) -> Void)?
    convenience init(title: String?, isOn: Bool, didChanged: ((ZJSwitchItem) -> Void)?) {
        self.init()
        self.title = title
        self.isOn = isOn
        self.didChanged = didChanged
    }
}

class ZJSwitchCell: UITableViewCell, ZJCellProtocol {
    var item: ZJSwitchItem!

    typealias ZJCellItemClass = ZJSwitchItem

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var switchButton: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cellPrepared() {
        labelTitle.text = item.title
        switchButton.isOn = item.isOn
    }

    @IBAction func valueChanged(_ sender: UISwitch) {
        item.isOn = sender.isOn
        item.didChanged?(item)
    }
}
