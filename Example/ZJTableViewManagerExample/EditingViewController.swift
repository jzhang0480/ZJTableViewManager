//
//  EditingViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/10.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Editing"
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(self.tableView);
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        var section = ZJTableViewSection(headerTitle: "DELETEABLE(可删除)")
        self.manager.add(section: section)
        for i in 0...3 {
            let item = ZJTableViewItem(title: "section 0, item " + String(i))
            item.editingStyle = .delete
            item.setDeletionHandler(deletionHandler: {[weak self] (item) in
                 self?.deleteConfirm(item: item, needConfirm: false)
            })
            section.add(item: item)
        }
        
        section = ZJTableViewSection(headerTitle: "Deletable with confirmation (删除需要确认)")
        self.manager.add(section: section)
        for i in 0...3 {
            let item = ZJTableViewItem(title: "section 1, item " + String(i))
            item.editingStyle = .delete
            item.setDeletionHandler(deletionHandler: {[weak self] (item) in
                self?.deleteConfirm(item: item)
            })
            section.add(item: item)
        }
        // Do any additional setup after loading the view.
    }
    
    func deleteConfirm(item: ZJTableViewItem, needConfirm: Bool = true) {
        if !needConfirm {
            print(item.cellTitle ?? "")
            item.delete()
            return;
        }
        
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure to delete " + (item.cellTitle)!, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            item.delete(.fade)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
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
