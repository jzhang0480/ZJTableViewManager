//
//  CustomExpandButtonCell.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/4/15.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit

class CustomExpandButtonCellItem: ZJExpandTreeCellItem {
    var title: String?
    var buttonTapCallBack: ((CustomExpandButtonCellItem) -> Void)?

    override init() {
        super.init()
        // 取消默认的点击展开处理
        selectionHandler = nil
        buttonTapCallBack = { callBackItem in
            callBackItem.toggleExpand()
        }
    }

    // 重写方法，目的是在展开事件结束后修改cell上面的按钮的标题
    @discardableResult override func toggleExpand() -> Bool {
        let bool = super.toggleExpand()
        if let cell = cell as? CustomExpandButtonCell {
            // 理论上是要尽量避免直接修改cell上面的控件的值，我这里修改了btnExpand.isSelected属性，同时在cellPrepared()里面设置btnExpand.isSelected = item.isExpand，确保是一致的。这样不会有复用的问题。
            cell.btnExpand.isSelected = bool
        }
        return bool
    }
}

class CustomExpandButtonCell: UITableViewCell, ZJCellProtocol {
    var item: CustomExpandButtonCellItem!
    typealias ZJCellItemClass = CustomExpandButtonCellItem
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var labelTitle: UILabel!
    func cellPrepared() {
        btnExpand.isSelected = item.isExpand
        labelTitle.text = item.title
    }

    @IBAction func actionExpand(_: Any) {
        item.buttonTapCallBack?(item)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
