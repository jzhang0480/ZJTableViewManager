//
//  ViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class ViewController: ZJBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        let titles = ["Forms", "Retractable", "CustomCells", "List", "Editing", ]
        for i in titles {
            let item = ZJTableViewItem(tableViewCellStyle: UITableViewCellStyle.default)
            item.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            item.systemCell?.textLabel?.text = i
            item.isSelectionAnimate = true
            section.add(item: item)
            
            item.setSelectionHandler(tempSelectHandler: { (item) in
                
                if i == "Forms" {
                    let vc = FormViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if i == "Retractable" {
                    let vc = RetractableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if i == "CustomCells" {
                    let vc = CustomCellViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if i == "List" {
                    
                }else if i == "Editing" {
                    
                }
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

