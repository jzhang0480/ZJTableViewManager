//
//  Level0Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class Level0CellItem: ZJExpandTreeCellItem {
    var title: String?
}

class Level0Cell: UITableViewCell, ZJCellProtocol {
    @IBOutlet var labelTitle: UILabel!
    var item: Level0CellItem!

    typealias ZJCellItemClass = Level0CellItem

    func cellWillAppear() {
        labelTitle.text = item.title
    }

    func cellDidAppear() {}

    func cellDidDisappear() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
