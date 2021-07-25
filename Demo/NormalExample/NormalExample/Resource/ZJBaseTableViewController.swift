//
//  ZJBaseTableViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

open class ZJBaseTableViewController: UIViewController {
    @IBOutlet var IBTableView: UITableView?
    public var tableView: UITableView!
    public var manager: ZJTableViewManager!
    public var tableViewStyle: UITableView.Style = UITableView.Style.plain

    override open func viewDidLoad() {
        super.viewDidLoad()
        if let tableView = IBTableView {
            self.tableView = tableView
        } else {
            tableView = UITableView(frame: view.bounds, style: tableViewStyle)
            view.addSubview(tableView)
        }
        manager = ZJTableViewManager(tableView: tableView)

        // Do any additional setup after loading the view.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if IBTableView == nil {
            tableView.frame = view.bounds
        }
    }

    override open func didReceiveMemoryWarning() {
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
