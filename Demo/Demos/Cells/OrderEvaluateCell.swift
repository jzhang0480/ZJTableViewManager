//
//  OrderEvaluateCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import ZJTableViewManager

class OrderEvaluateCell: ZJTableViewCell, UITextViewDelegate {
    @IBOutlet weak var imgGoods: UIImageView!
    @IBOutlet weak var starView: SwiftyStarRatingView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starView.addTarget(self, action: #selector(starViewEndChange(view:)), for: .valueChanged)
        // Initialization code
    }
    
    override func cellWillAppear() {
        super.cellWillAppear()
        let item = self.item as! OrderEvaluateItem
        self.labelTitle.text = item.title
        self.starView.value = item.starValue
        self.starView.isEnabled = item.editable!
        
    }
    
    @objc func starViewEndChange(view: SwiftyStarRatingView) {
        let item = self.item as! OrderEvaluateItem
        item.starValue = view.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
