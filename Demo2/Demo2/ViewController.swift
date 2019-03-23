//
//  ViewController.swift
//  Demo2
//
//  Created by Javen on 2018/3/14.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// 左侧分类的tableView
    @IBOutlet weak var categoryTableView: UITableView!
    /// 右侧商品的tableview
    @IBOutlet weak var productTableView: UITableView!
    var categoryManager: ZJTableViewManager!
    var productManager: ZJTableViewManager!
    //是否在向上滚动
    var isScrollUp:Bool = false
    var lastOffsetY:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化tableviewManager
        self.categoryManager = ZJTableViewManager(tableView: self.categoryTableView)
        self.productManager = ZJTableViewManager(tableView: self.productTableView)
        self.productManager.delegate = self
        //假数据
        let arrCategory = ["分类1","分类2","分类3","分类4","分类5","分类6"]
        let arrProduct = ["面包", "蛋糕", "香蕉", "牛奶", "饼干", "猫粮"]
        
        //添加分类数据
        let categorySection = ZJTableViewSection()
        self.categoryManager?.add(section: categorySection)
        for category in arrCategory {
            let categoryItem = ZJTableViewItem(title: category)
            categoryItem.isAutoDeselect = false
            categorySection.add(item: categoryItem)
            //分类的点击事件
            categoryItem.setSelectionHandler(selectHandler: {[weak self] (item) in
                self?.productManager.tableView.scrollToRow(at: IndexPath(row: 0, section: item.indexPath.row), at: .top, animated: true)
            })
        }
        
        //添加商品数据
        for category in arrCategory {
            //添加分区标题
            let sectionHeader = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
            sectionHeader.text = category
            sectionHeader.backgroundColor = UIColor.red
            let section = ZJTableViewSection(headerView: sectionHeader)
            self.productManager.add(section: section)
            //商品列表滑动时与分类列表联动
            section.setHeaderWillDisplayHandler({[weak self] (currentSection) in
                //手动拖才和左边联动
                if (self?.productManager.tableView.isDragging ?? false && !(self?.isScrollUp ?? true)){
                    let currentSection = self?.productTableView.indexPathsForVisibleRows?.first?.section ?? 0
                    self?.categoryTableView.selectRow(at: IndexPath(item: currentSection, section: 0), animated: false, scrollPosition: .middle)
                }
            })
            
            section.setHeaderDidEndDisplayHandler {[weak self] (currentSection) in
                //手动拖才和左边联动
                if (self?.productManager.tableView.isDragging ?? false && (self?.isScrollUp ?? true)){
                     self?.categoryTableView.selectRow(at: IndexPath(item: currentSection.index + 1, section: 0), animated: false, scrollPosition: .middle)
                }else if (self?.productManager.tableView.isDragging ?? false && !(self?.isScrollUp ?? true)){
                    let currentSection = self?.productTableView.indexPathsForVisibleRows?.first?.section ?? 0
                    self?.categoryTableView.selectRow(at: IndexPath(item: currentSection, section: 0), animated: false, scrollPosition: .middle)
                }
            }
            //添加商品
            for product in arrProduct {
                let item = ZJTableViewItem(title: product)
                item.cellHeight = 90
                section.add(item: item)
            }
        }
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:ZJTableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollUp = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
    
    
}
