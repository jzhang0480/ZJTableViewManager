//
//  CustomSectionHeaderView.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/4/15.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import UIKit

class CustomSectionHeaderView: UIView {

    class func view() -> CustomSectionHeaderView {
        let nib = UINib(nibName: "CustomSectionHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: nil, options: nil)[0] as! CustomSectionHeaderView
        headerView.frame.size.height = 44
        return headerView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
