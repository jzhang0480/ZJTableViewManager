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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AutomaticHeight"
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(self.tableView);
        self.manager = ZJTableViewManager(tableView: self.tableView)
        self.manager.register(AutomaticHeightCell.self, AutomaticHeightCellItem.self)
        let section = ZJTableViewSection(headerTitle: "Section")
        manager.add(section: section)
        
        let datas = [["title":"测试标题测试标题", "content":"测试内容测试内容测试内容"],
                    ["title":"测试标题测试标题测试标题测试标题测试标题", "content":"测试内容测试内容测试内容测试内容测试内容测试内容"],
                    ["title":"测试标题测试标题", "content":"测试内容测试内容测试内容"],
                    ["title":"测试标题", "content":"测试内容"],
                    ["title":"测试标题测试标题", "content":"测试内容测试内容测试内容"],
                    ["title":"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题", "content":"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容"],
                    ["title":"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题", "content":"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容"]]
        for data in datas {
            let item = AutomaticHeightCellItem()
            item.title = data["title"]
            item.content = data["content"]
            //在autoHeight方法里对cell赋值，就会自动计算高度
            item.autoHeight(manager, AutomaticHeightCell.self) { (cell) in
                cell.configWithItem(item: item)
            }
            
            section.add(item: item)
        }
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
