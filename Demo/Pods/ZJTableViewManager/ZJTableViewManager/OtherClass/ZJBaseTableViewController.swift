//
//  ZJBaseTableViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

open class ZJBaseTableViewController: UIViewController {
    @IBOutlet weak var IBTableView: UITableView?
    public var tableView: UITableView!
    public var manager: ZJTableViewManager!
    public var tableViewStyle: UITableViewStyle = UITableViewStyle.plain
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let tableView = self.IBTableView {
            self.tableView = tableView
        }else{
            self.tableView = UITableView(frame: self.view.bounds, style: self.tableViewStyle)
            self.view.addSubview(self.tableView);
        }
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        // Do any additional setup after loading the view.
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.IBTableView == nil {
            self.tableView.frame = self.view.bounds
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

