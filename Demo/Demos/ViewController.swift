//
//  ViewController.swift
//  Demos
//
//  Created by Javen on 2018/3/8.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit
import ZJTableViewManager

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var manager: ZJTableViewManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        //register cell
        self.manager?.register(OrderEvaluateCell.self, OrderEvaluateItem.self)
        self.manager?.register(ZJPictureTableCell.self, ZJPictureTableItem.self)
        
        //add section
        let section = ZJTableViewSection(headerHeight: 10, color: UIColor.init(white: 0.9, alpha: 1))
        self.manager?.add(section: section)
        
        //add cells
        for i in 0...10 {
            //评价cell
            section.add(item: OrderEvaluateItem(title: "评价"))
            let textItem = ZJTextItem(text: nil, placeHolder: "请在此输入您的评价~", didChanged: nil)
            textItem.isHideSeparator = true
            section.add(item: textItem)
            
            //图片cell
            if i%2 == 1 {
                //只展示图片
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self, pictures: [#imageLiteral(resourceName: "demo_image_1"),#imageLiteral(resourceName: "demo_image_2"),#imageLiteral(resourceName: "demo_image_3"),#imageLiteral(resourceName: "demo_image_4"),#imageLiteral(resourceName: "demo_image_5")])
                pictureItem.type = .read
                section.add(item: pictureItem)
            }else{
                //添加图片
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self)
                pictureItem.type = .edit
                section.add(item: pictureItem)
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

