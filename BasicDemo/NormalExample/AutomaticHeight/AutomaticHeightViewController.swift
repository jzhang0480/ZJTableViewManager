//
//  AutomaticHeightViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit

class AutomaticHeightViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section = ZJTableViewSection()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutomaticHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(AutomaticHeightCell.self, AutomaticHeightCellItem.self)
        manager.add(section: section)

        // 模拟网络请求
        httpRequest(view: view) {
            // 网络请求完成
            self.showData()
        }
        // Do any additional setup after loading the view.
    }

    func showData() {
        let array = getFeedData()
        for feed in array {
            let item = AutomaticHeightCellItem()
            item.feed = feed
            item.autoHeight(manager)
            section.add(item: item)
        }
        manager.reload()
    }
}
