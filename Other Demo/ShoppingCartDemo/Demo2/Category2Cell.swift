//
//  Category2Cell.swift
//  Demo2
//
//  Created by Javen on 2019/5/14.
//  Copyright © 2019 上海勾芒信息科技. All rights reserved.
//

import UIKit
import ZJTableViewManager

class Category2CellItem: ZJTableViewItem {
    var title: String!
}

class Category2Cell: UITableViewCell, ZJCellProtocol {
    var item: Category2CellItem!

    typealias ZJCelltemClass = Category2CellItem

    func cellWillAppear() {
        categoryTitle.text = item.title
    }

    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
