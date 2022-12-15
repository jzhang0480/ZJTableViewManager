//
//  Level3Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class Level3CellItem: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { Level3Cell.self }
    var title: String?
    convenience init(title: String?) {
        self.init()
        self.height = UITableView.automaticDimension
        self.title = title
    }
}

class Level3Cell: ZJCell<Level3CellItem>, ZJCellable {
    @IBOutlet weak var titleL: UILabel!

    func cellPrepared() {
        titleL.text = item.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
