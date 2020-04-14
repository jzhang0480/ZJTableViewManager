//
//  ZJSwitchCell.swift
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
    public convenience init(title: String?, isOn: Bool, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.title = title
        self.isOn = isOn
        self.didChanged = didChanged
    }
}

open class ZJSwitchCell: UITableViewCell, ZJCellProtocol {
    public var item: ZJSwitchItem!

    public typealias ZJCelltemClass = ZJSwitchItem

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var switchButton: UISwitch!

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func cellWillAppear() {
        labelTitle.text = item.title
        switchButton.isOn = item.isOn
    }

    @IBAction func valueChanged(_ sender: UISwitch) {
        item.isOn = sender.isOn
        item.didChanged?(item)
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
