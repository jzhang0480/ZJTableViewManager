//
//  FormViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class BasicViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic"

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

//        manager.register(ZJTextCell.self, ZJTextItem.self)
//        manager.register(ZJTextFieldCell.self, ZJTextFieldItem.self)
//        manager.register(ZJSwitchCell.self, ZJSwitchItem.self)

        // Custom SectionHeader
        let headerView = CustomSectionHeaderView.view()
        let section = ZJSection(headerView: headerView)
        manager.add(section: section)

        // Custom Cell
        // Simple String
        section.add(item: ZJSystemStyleItem(labelText: "Simple String"))

        // Full length text field
        section.add(item: ZJTextFieldItem(title: nil, placeHolder: "Full length text field", text: nil, isFullLength: true, didChanged: nil))

        // Password
        let passwordItem = ZJTextFieldItem(title: "Password", placeHolder: "Password Item", text: nil, didChanged: { item in
            if let text = item.text {
                zj_log(text)
            }
        })
        passwordItem.isSecureTextEntry = true
        section.add(item: passwordItem)

        // Switch Item
        section.add(item: ZJSwitchItem(title: "Switch Item", isOn: false, didChanged: { item in
            zj_log(item.isOn)
        }))

        // Text Item
        section.add(item: ZJTextItem(text: nil, placeHolder: "Text Item", didChanged: { item in
            if let text = item.text {
                zj_log(text)
            }
        }))

        manager.reload()
    }
}
