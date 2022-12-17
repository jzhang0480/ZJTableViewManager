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
    var previousSelectedItem: SelectionCellItem?
    var selectedItems: [SelectionCellItem] = []

    /// 是否允许多选
    var isAllowMultiSelection: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selection"

        // Setup manager
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        // Add section

        manager.add(section: section)
        for _ in 0 ..< 100 {
            let item = SelectionCellItem()
            section.add(item: item)
            item.setSelection { [weak self] item in
                if self?.isAllowMultiSelection == true {
                    item.isSelected = !item.isSelected
                } else {
                    self?.previousSelectedItem?.isSelected = false
                    item.isSelected = true
                    self?.previousSelectedItem = item
                }

                item.manager.reload()
            }
        }
    }
}
