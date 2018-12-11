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
        
        var datas = [[String:String]]()
        for _ in 0..<50 {
            //注: randomStr()是随机产生字符串的方法
            datas.append(["title":randomStr(), "content":randomStr(), "right":randomStr()])
        }
        for data in datas {
            let item = AutomaticHeightCellItem()
            item.title = data["title"]
            item.content = data["content"]
            //计算高度
            item.autoHeight(manager)
            section.add(item: item)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //随机产生不确定长度字符串
    func randomStr() -> String{
        let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        let len = arc4random_uniform(100)
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}
