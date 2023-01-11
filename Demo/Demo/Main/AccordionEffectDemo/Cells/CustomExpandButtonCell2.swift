//
//  CustomExpandButtonCell2.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/4/15.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class CustomExpandButtonCell2Item2: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { CustomExpandButtonCell2.self }
    var title: String?
    var buttonTapCallBack: ((CustomExpandButtonCell2Item2) -> Void)?

    override init() {
        super.init()
        // 清空默认的点击展开处理
        setSelection(nil)
        height = 50
    }
}

class CustomExpandButtonCell2: ZJCell<CustomExpandButtonCell2Item2>, ZJCellable {
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var labelTitle: UILabel!
    func cellPreparedForReuse() {
        btnExpand.isSelected = item.isExpand
        labelTitle.text = item.title
    }

    @IBAction func actionExpand(_ sender: UIButton) {
        item.willExpand = {
            sender.isSelected = $0.isExpand
        }
        item.buttonTapCallBack?(item)
    }
}
