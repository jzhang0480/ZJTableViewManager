//
//  EditingViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/10.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class EditingViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SlideDelete"

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        var section = ZJSection(headerTitle: "DELETEABLE")
        manager.add(section: section)
        for i in 0 ... 3 {
            let item = ZJSystemStyleItem(labelText: "section 0, row " + String(i))
            item.editingStyle = .delete
            item.setDeletion { [weak self] item in
                self?.deleteConfirm(item: item, needConfirm: false)
            }
            section.add(item: item)
        }

        section = ZJSection(headerTitle: "Deletable with confirmation")
        manager.add(section: section)
        for i in 0 ... 3 {
            let item = ZJSystemStyleItem(labelText: "section 1, row " + String(i))
            item.editingStyle = .delete
            item.setDeletion { [weak self] item in
                self?.deleteConfirm(item: item)
            }
            section.add(item: item)
        }

        manager.reload()
    }

    func deleteConfirm(item: ZJSystemStyleItem, needConfirm: Bool = true) {
        if !needConfirm {
            zj_log((item.labelText ?? "") + " deleted！")
            item.delete()
            return
        }

        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure to delete " + (item.labelText)!, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            zj_log((item.labelText ?? "") + " deleted！")
            item.delete(.fade)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
