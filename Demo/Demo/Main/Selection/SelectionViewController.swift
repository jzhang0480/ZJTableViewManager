//
//  SelectionViewController.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/5/20.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit
import ZJTableViewManager

class SelectionViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    let section = ZJSection()
    var selectionTypeBtn: UIBarButtonItem!
    var selectedItem: SelectionCellItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selection"
        selectionTypeBtn = UIBarButtonItem(title: "单选", style: .plain, target: self, action: #selector(switchSelectionType(button:)))
        let validateBtn = UIBarButtonItem(title: "获取选中项", style: .plain, target: self, action: #selector(validateSelectionItems(button:)))
        let selectAllBtn = UIBarButtonItem(title: "全选", style: .plain, target: self, action: #selector(selectAll(button:)))
        navigationItem.rightBarButtonItems = [validateBtn, selectionTypeBtn, selectAllBtn]

        // Setup manager
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
//        manager.register(SelectionCell.self, SelectionCellItem.self)

        // Add section

        manager.add(section: section)

        // Add Cell
        for _ in 0 ..< 100 {
            let item = SelectionCellItem()
            section.add(item: item)
            if section.items.count == 2 {
                item.isAllowSelect = false
            }

            // 实现单选情况下的反选操作
            item.setSelectionHandler { [unowned self] (callBackItem: SelectionCellItem) in
                if self.tableView.allowsMultipleSelection == true {
                    return
                }

                if callBackItem.isSelected, callBackItem == self.selectedItem {
                    self.selectedItem = nil
                    callBackItem.deselect()
                } else {
                    self.selectedItem = callBackItem
                }
            }
            // 实现单选情况下的反选操作
        }
    }

    @objc func switchSelectionType(button: UIBarButtonItem) {
        if button.title == "单选" {
            button.title = "多选"
            tableView.allowsMultipleSelection = true
        } else if button.title == "多选" {
            button.title = "单选"
            tableView.allowsMultipleSelection = false
            section.items.first?.select(animated: true, scrollPosition: .top)
        }
    }

    @objc func validateSelectionItems(button _: UIBarButtonItem) {
        if selectionTypeBtn.title == "单选" {
            if let item = manager.selectedItem() as? SelectionCellItem {
                zj_log("item at \(item.indexPath.row)")
            } else {
                zj_log("no item be selected")
            }
        } else if selectionTypeBtn.title == "多选" {
            let items: [SelectionCellItem] = manager.selectedItems()
            zj_log("multi-selected items as follows:")
            zj_log(items.map { "item at \($0.indexPath.row)" })
        }
    }

    @objc func selectAll(button _: UIBarButtonItem) {
        selectionTypeBtn.title = "多选"
        tableView.allowsMultipleSelection = true
        manager.selectItems(section.items)
    }
}
