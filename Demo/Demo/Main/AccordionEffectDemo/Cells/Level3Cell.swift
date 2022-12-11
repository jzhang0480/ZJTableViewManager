//
//  Level3Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

class Level3CellItem: ZJAccordionItem {
    var title: String?
    convenience init(title: String?) {
        self.init()
        self.cellHeight = UITableView.automaticDimension
        self.title = title
    }
}

class Level3Cell: UITableViewCell, ZJCellProtocol {
    @IBOutlet weak var titleL: UILabel!
    var item: Level3CellItem!

    typealias ZJCellItemClass = Level3CellItem

    func cellPrepared() {
        titleL.text = item.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
