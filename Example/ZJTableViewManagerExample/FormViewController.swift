//
//  FormViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class FormViewController: ZJBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forms"
        self.tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        //Simple String
        section.add(item: ZJTableViewItem(title: "Simple String"))
        
        //Full length text field
        section.add(item: ZJTextFieldItem(title: nil, placeHolder: "Full length text field", text: nil, isFullLength: true, didChanged: nil))
        
        //Text Item
        section.add(item: ZJTextFieldItem(title: "Text Item", placeHolder: "Text", text: nil, didChanged: { (item) in
            if let text = (item as! ZJTextFieldItem).text {
                print(text)
            }
        }))
        
        //Password
        let passwordItem = ZJTextFieldItem(title: "Password", placeHolder: "Password Item", text: nil, didChanged: { (item) in
            if let text = (item as! ZJTextFieldItem).text {
                print(text)
            }
        })
        passwordItem.isSecureTextEntry = true
        section.add(item: passwordItem)
        
        //Switch Item
        section.add(item: ZJSwitchItem(title: "Switch Item", isOn: false, didChanged: { (item) in
            print((item as! ZJSwitchItem).isOn)
        }))
        
        
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
