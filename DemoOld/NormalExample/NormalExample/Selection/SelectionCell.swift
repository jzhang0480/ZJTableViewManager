//
//  SelectionCell.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/5/20.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit

class SelectionCellItem: ZJTableViewItem {
    override init() {
        super.init()
        selectionStyle = .none
    }
}

class SelectionCell: UITableViewCell, ZJCellProtocol {
    typealias ZJCellItemClass = SelectionCellItem
    var item: SelectionCellItem!
    @IBOutlet var img: UIImageView!
    @IBOutlet var titleL: UILabel!

    func cellPrepared() {
        titleL.text = "Item \(item.indexPath.row)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            img.isHidden = false
        } else {
            img.isHidden = true
        }
    }
}
