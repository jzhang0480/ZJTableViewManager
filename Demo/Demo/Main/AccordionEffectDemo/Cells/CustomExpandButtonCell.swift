//
//  CustomExpandButtonCell.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/4/15.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class CustomExpandButtonCellItem: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { CustomExpandButtonCell.self }
    var title: String?
    var buttonTapCallBack: ((CustomExpandButtonCellItem) -> Void)?

    override init() {
        super.init()
        // 清空默认的点击展开处理
        setSelection(nil)
        buttonTapCallBack = { callBackItem in
            callBackItem.toggleExpand()
        }
        height = 50
    }
}

class CustomExpandButtonCell: ZJCell<CustomExpandButtonCellItem>, ZJCellable {
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var labelTitle: UILabel!
    func cellPreparedForReuse() {
        btnExpand.isSelected = item.isExpand
        labelTitle.text = item.title
    }

    @IBAction func actionExpand(_ sender: UIButton) {
        let isExpand = item.toggleExpand()
        sender.isSelected = isExpand
    }
}
