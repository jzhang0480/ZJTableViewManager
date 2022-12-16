//
//  UpdateHeightViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Jie Zhang on 2019/8/15.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class UpdateHeightViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section: ZJSection!
    var lastOpenItem: CardTableViewCellItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpdateHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
//        manager.register(CardTableViewCell.self, CardTableViewCellItem.self)
        section = ZJSection()
        manager.add(section: section)

        for index in 0 ..< 5 {
            let item = CardTableViewCellItem()
            section.add(item: item)
            item.zPosition = CGFloat(index)
            // cell tap event
            item.setSelection { [unowned self] selectItem in
                self.cellTapEvent(item: selectItem)
            }
        }

        if let lastItem = section.items.last as? CardTableViewCellItem {
            // Last cell keep open and don't respond to the tap event
            lastItem.openCard()
            lastItem.setSelection(nil)
        }

        manager.reload()
    }

    func cellTapEvent(item: CardTableViewCellItem) {
        item.isOpen = !item.isOpen
        if item.isOpen {
            item.openCard()
            if lastOpenItem != item { // 关闭上一次打开的cell/ close the cell that was last opened
                lastOpenItem?.closeCard()
                lastOpenItem = item
            }
        } else {
            item.closeCard()
        }

        manager.updateHeight()
        tableView.fixCellBounds()
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

// https://stackoverflow.com/questions/62899815/shadow-cell-flickers-when-animating-the-height
extension UITableView {
    func fixCellBounds() {
        DispatchQueue.main.async { [weak self] in
            for cell in self?.visibleCells ?? [] {
                cell.layer.masksToBounds = false
                cell.contentView.layer.masksToBounds = false
            }
        }
    }
}
