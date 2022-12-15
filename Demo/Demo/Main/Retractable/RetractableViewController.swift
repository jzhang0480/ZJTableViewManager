//
//  RetractableViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class RetractableViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Retractable"
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)

        manager = ZJTableViewManager(tableView: tableView)
        tableView.tableFooterView = UIView()

        // Add main section
        let section = ZJSection()
        manager.add(section: section)

        var collapsedItems: [ZJSystemStyleItem] = []
        var expandedItems: [ZJSystemStyleItem] = []

        // collapsed
        for i in 1 ... 4 {
            collapsedItems.append(ZJSystemStyleItem(text: "Test Item " + String(i)))
        }

        let moreItem = ZJSystemStyleItem(text: "Show More")
        moreItem.accessoryType = .disclosureIndicator
        collapsedItems.append(moreItem)
        moreItem.setSelectionHandler { _ in
            section.replaceItemsFrom(items: expandedItems)
            section.reload(UITableView.RowAnimation.automatic)
        }
        section.replaceItemsFrom(items: collapsedItems)

        // expanded
        for i in 1 ... 7 {
            expandedItems.append(ZJSystemStyleItem(text: "Test Item " + String(i)))
        }

        let lessItem = ZJSystemStyleItem(text: "Show Less")
        lessItem.accessoryType = .disclosureIndicator

        lessItem.setSelectionHandler { _ in
            section.replaceItemsFrom(items: collapsedItems)
            section.reload(UITableView.RowAnimation.automatic)
        }
        expandedItems.append(lessItem)

        manager.reload()

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
