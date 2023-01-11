//
//  SelectionCell.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/5/20.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class SelectionCellItem: ZJItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { SelectionCell.self }
    var isSelected: Bool = false

    override init() {
        super.init()
        selectionStyle = .none
    }
}

class SelectionCell: ZJCell<SelectionCellItem>, ZJCellable {
    @IBOutlet var img: UIImageView!
    @IBOutlet var titleL: UILabel!

    func cellPreparedForReuse() {
        titleL.text = "Item \(item.indexPath.row)"
        img.isHidden = !item.isSelected
    }
}
