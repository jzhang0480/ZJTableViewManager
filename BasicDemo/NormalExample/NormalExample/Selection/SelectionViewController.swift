//
//  SelectionViewController.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/5/20.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    let section = ZJTableViewSection()
    var selectionTypeBtn: UIBarButtonItem!
    
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
        manager.register(SelectionCell.self, SelectionCellItem.self)
        
        // Add section
        
        manager.add(section: section)
        
        // Add Cell
        for _ in 0..<100 {
            let item = SelectionCellItem()
            section.add(item: item)
            item.setSelectionHandler { (callBackItem: SelectionCellItem) in
                
            }
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
    
    @objc func validateSelectionItems(button: UIBarButtonItem) {
        if selectionTypeBtn.title == "单选" {
            if let item = manager.selectedItem() as?  SelectionCellItem {
                print("item at \(item.indexPath.row)")
            }else{
                print("no item be selected")
            }
        } else if selectionTypeBtn.title == "多选" {
            let items: [SelectionCellItem] = manager.selectedItems()
            print("multi-selected items as follows:")
            print(items.map({"item at \($0.indexPath.row)"}))
            
        }
    }
    
    @objc func selectAll(button: UIBarButtonItem) {
        selectionTypeBtn.title = "多选"
        tableView.allowsMultipleSelection = true
        manager.selectItems(section.items)
    }
}
