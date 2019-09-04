//
//  UpdateHeightViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Jie Zhang on 2019/8/15.
//  Copyright © 2019 上海勾芒信息科技. All rights reserved.
//

import UIKit

class UpdateHeightViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section: ZJTableViewSection!
    var lastOpenItem: CardTableViewCellItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpdateHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(CardTableViewCell.self, CardTableViewCellItem.self)
        section = ZJTableViewSection()
        manager.add(section: section)

        for index in 0 ..< 5 {
            let item = CardTableViewCellItem()
            section.add(item: item)
            item.zPosition = CGFloat(index)
            // cell tap event
            item.setSelectionHandler { [weak self] selectItem in
                self?.cellTapEvent(item: selectItem as! CardTableViewCellItem)
            }
        }

        if let lastItem = section.items.last {
            let item = (lastItem as! CardTableViewCellItem)
            // Last cell keep open and don't response tap event
            item.openCard()
            item.selectionHandler = nil
        }

        manager.reload()

        // Do any additional setup after loading the view.
    }

    func cellTapEvent(item: CardTableViewCellItem) {
        item.isOpen = !item.isOpen
        if item.isOpen {
            item.openCard()
            if lastOpenItem != item { // 关闭上一次打开的cell close the cell that was last opened
                lastOpenItem?.closeCard()
                lastOpenItem = item
            }
        } else {
            item.closeCard()
        }
        manager.updateHeight()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
