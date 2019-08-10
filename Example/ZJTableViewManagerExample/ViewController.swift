//
//  ViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        FPSCounter.showInStatusBar()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        manager.add(section: section)

        let titles = ["Forms", "Retractable", "CustomCells", "Editing", "Sections", "List", "AutomaticHeight", "ExpandTree"]
        for i in titles {
            let item = ZJTableViewItem(title: i)
            item.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            item.isAutoDeselect = true
            section.add(item: item)

            item.setSelectionHandler(selectHandler: { _ in

                if i == "Forms" {
                    let vc = FormViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "Retractable" {
                    let vc = RetractableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "CustomCells" {
                    let vc = CustomCellViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "Editing" {
                    let vc = EditingViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "Sections" {
                    let vc = SectionsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "AutomaticHeight" {
                    let vc = AutomaticHeightViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "ExpandTree" {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ExpandTreeViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
