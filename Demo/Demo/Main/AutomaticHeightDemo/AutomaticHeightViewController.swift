//
//  AutomaticHeightViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class AutomaticHeightViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section = ZJSection()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutomaticHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
//        manager.register(AutomaticHeightCell.self, AutomaticHeightCellItem.self)
        manager.add(section: section)

        // 模拟网络请求
        mockHttpRequest(view: view) {
            // 网络请求完成
            self.showData()
        }
    }

    func showData() {
        // 获取假数据
        let array = getFeedData()
        for feed in array {
            let item = AutomaticHeightCellItem()
            item.feed = feed
            // 计算高度
            item.autoHeight(manager)
            // 把cell加入进section
            section.add(item: item)
        }
        manager.reload()
    }
}
