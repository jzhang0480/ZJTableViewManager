//
//  ViewController.swift
//  Demo2
//
//  Created by Javen on 2018/3/14.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit
@_exported import ZJTableViewManager

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
        categoryManager.register(Category1Cell.self, Category1CellItem.self)
        self.productManager = ZJTableViewManager(tableView: self.productTableView)
        self.productManager.delegate = self
        //假数据
        let arrCategory = ["分类1","分类2","分类3","分类4","分类5","分类6"]
        let arrProduct = ["面包", "蛋糕", "香蕉", "牛奶", "饼干", "猫粮"]
        //添加分类数据
        let categorySection = ZJTableViewSection()
        self.categoryManager?.add(section: categorySection)
        for category in arrCategory {
            let categoryItem = Category1CellItem()
            categoryItem.title = category
            categoryItem.isAutoDeselect = false
            categorySection.add(item: categoryItem)
            //分类的点击事件
            categoryItem.setSelectionHandler(selectHandler: {[weak self] (item) in
                self?.productManager.tableView.scrollToRow(at: IndexPath(row: 0, section: item.indexPath.row), at: .top, animated: true)
            })
        }
        //给商品tableView添加商品数据
        for category in arrCategory {
            //添加分区标题
            let sectionHeader = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
            sectionHeader.text = category
            sectionHeader.backgroundColor = UIColor.red
            let section = ZJTableViewSection(headerView: sectionHeader)
            self.productManager.add(section: section)
            //商品列表滑动时与分类列表联动
            //商品列表section header显示的回调
            section.setHeaderWillDisplayHandler({[weak self] (currentSection) in
                //手动拖拽事件结束并且是向下滚动，根据商品tableView最上面的section控制左边分类tableView的选中分类
                if ((self?.productManager.tableView.isDragging)! && !(self?.isScrollUp)!){
                    let currentSection = self?.productTableView.indexPathsForVisibleRows?.first?.section ?? 0
                    self?.categoryTableView.selectRow(at: IndexPath(item: currentSection, section: 0), animated: false, scrollPosition: .middle)
                }
            })
            //商品列表section header消失的回调
            section.setHeaderDidEndDisplayHandler {[weak self] (currentSection) in
                //手动拖拽事件结束并且是向上滚动，说明现在消失的section下下一个section出现了，所以左边要选中下一个section
                if ((self?.productManager.tableView.isDragging)! && (self?.isScrollUp)!){
                     self?.categoryTableView.selectRow(at: IndexPath(item: currentSection.index + 1, section: 0), animated: false, scrollPosition: .middle)
                }
            }
            //添加商品
            for product in arrProduct {
                let item = ZJTableViewItem(title: product)
                item.cellHeight = 90
                section.add(item: item)
            }
        }
        //先默认选中categoryTableView分类的第一个cell
        self.categoryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
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

