//
//  OrderEvaluateCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import SwiftyStarRatingView
import UIKit
import ZJTableViewManager

class OrderEvaluateItem: ZJTableViewItem {
    var title: String?
    var evaluate: String?
    var starValue: CGFloat = 1
    var editable: Bool?
    
    override init() {
        super.init()
        self.cellHeight = 55
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    convenience init(eTitle: String!, starValue: CGFloat = 1, editable: Bool = true) {
        self.init()
        self.title = eTitle
        self.starValue = starValue
        self.editable = editable
    }
}

class OrderEvaluateCell: UITableViewCell, ZJCellProtocol, UITextViewDelegate {
    var item: OrderEvaluateItem!
    
    typealias ZJCelltemClass = OrderEvaluateItem
    
    func cellWillAppear() {
        labelTitle.text = item.title
        starView.value = item.starValue
        starView.isEnabled = item.editable!
    }
    
    @IBOutlet var imgGoods: UIImageView!
    @IBOutlet var starView: SwiftyStarRatingView!
    @IBOutlet var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starView.addTarget(self, action: #selector(starViewEndChange(view:)), for: .valueChanged)
        // Initialization code
    }

    @objc func starViewEndChange(view: SwiftyStarRatingView) {
        item.starValue = view.value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
