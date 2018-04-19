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
        self.title = "Retractable"
        self.tableView.tableFooterView = UIView()
        
        // Add main section
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        var collapsedItems:[ZJTableViewItem] = []
        var expandedItems:[ZJTableViewItem] = []
        
        //collapsed
        for i in 1...4 {
            collapsedItems.append(ZJTableViewItem(title: "Test Item " + String(i)))
        }
        
        let moreItem = ZJTableViewItem(title: "Show More")
        moreItem.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        collapsedItems.append(moreItem)
        moreItem.setSelectionHandler { (item) in
            section.replaceItemsFrom(array: expandedItems)
            section.reload(UITableViewRowAnimation.automatic)
        }
        section.replaceItemsFrom(array: collapsedItems)
        
        
        //expanded
        for i in 1...7 {
             expandedItems.append(ZJTableViewItem(title: "Test Item " + String(i)))
        }
        
        let lessItem = ZJTableViewItem(title: "Show Less")
        lessItem.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        lessItem.setSelectionHandler { (item) in
            section.replaceItemsFrom(array: collapsedItems)
            section.reload(UITableViewRowAnimation.automatic)
        }
        expandedItems.append(lessItem)
        
        
        
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
