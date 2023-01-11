//
//  Level0Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class Level0CellItem: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { Level0Cell.self }
    var title: String?
    override init() {
        super.init()
        height = 50
    }
}

class Level0Cell: ZJCell<Level0CellItem>, ZJCellable {
    @IBOutlet var labelTitle: UILabel!

    func cellPreparedForReuse() {
        labelTitle.text = item.title
    }

    func cellDidEndDisplaying() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
