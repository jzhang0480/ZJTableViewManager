//
//  RetractableViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class RetractableViewController: ZJBaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Retractable"
        tableView.tableFooterView = UIView()

        // Add main section
        let section = ZJTableViewSection()
        manager.add(section: section)

        var collapsedItems: [ZJTableViewItem] = []
        var expandedItems: [ZJTableViewItem] = []

        // collapsed
        for i in 1 ... 4 {
            collapsedItems.append(ZJTableViewItem(title: "Test Item " + String(i)))
        }

        let moreItem = ZJTableViewItem(title: "Show More")
        moreItem.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        collapsedItems.append(moreItem)
        moreItem.setSelectionHandler { _ in
            section.replaceItemsFrom(array: expandedItems)
            section.reload(UITableView.RowAnimation.automatic)
        }
        section.replaceItemsFrom(array: collapsedItems)

        // expanded
        for i in 1 ... 7 {
            expandedItems.append(ZJTableViewItem(title: "Test Item " + String(i)))
        }

        let lessItem = ZJTableViewItem(title: "Show Less")
        lessItem.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        lessItem.setSelectionHandler { _ in
            section.replaceItemsFrom(array: collapsedItems)
            section.reload(UITableView.RowAnimation.automatic)
        }
        expandedItems.append(lessItem)

        manager.reload()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
