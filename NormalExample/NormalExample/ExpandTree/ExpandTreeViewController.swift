//
//  ViewController.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/19.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class ExpandTreeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section = ZJTableViewSection()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ExpandTree"
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(Level0Cell.self, Level0CellItem.self)
        manager.register(Level1Cell.self, Level1CellItem.self)
        manager.register(Level2Cell.self, Level2CellItem.self)
        manager.register(Level3Cell.self, Level3CellItem.self)
        manager.add(section: section)

        // level 0
        let item0 = Level0CellItem()
        item0.level = 0
        section.add(item: item0)
        // 如果isExpand为true，则下一级的item（也就是item1）必须加入section
        item0.isExpand = true
        // level 1
        for _ in 0 ..< 3 {
            let item1 = Level1CellItem()
            // level仅用于记录层级，可以不赋值
            item1.level = 1
            item1.isExpand = false
            section.add(item: item1)
            item0.arrNextLevel.append(item1)

            // level 2
            for _ in 0 ..< 3 {
                let item2 = Level2CellItem()
                // 如果isExpand为false，则后面就不用把item加入section
                item2.isExpand = false
                item1.arrNextLevel.append(item2)

                // level 3
                for _ in 0 ..< 3 {
                    let item3 = Level3CellItem()
                    item3.isExpand = false
                    item2.arrNextLevel.append(item3)
                }
            }
        }
        manager.reload()

        // Do any additional setup after loading the view, typically from a nib.
    }
}
