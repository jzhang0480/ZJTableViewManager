//
//  CustomCellViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class CustomCellViewController: ZJBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forms"
        
        //custom cell must regist cell class first（support xib cell and code cell）
        self.manager.register(NotSeriousCustomCell.self, NotSeriousCustomItem.self)
        
        
        self.tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        
        section.add(item: NotSeriousCustomItem())
        section.add(item: NotSeriousCustomItem())
        section.add(item: NotSeriousCustomItem())
        section.add(item: NotSeriousCustomItem())
        
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
