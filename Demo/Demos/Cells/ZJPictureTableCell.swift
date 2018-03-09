//
//  ZJPictureTableCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
import ImagePicker
import SKPhotoBrowser
import ZJTableViewManager

class ZJPictureTableCell: ZJTableViewCell {
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var myItem: ZJPictureTableItem!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100), collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.collectionView)
        self.collectionView.register(UINib(nibName: "ZJPictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ZJPictureCollectionCell")
        self.collectionView.isScrollEnabled = false;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    
    override func cellWillAppear() {
        super.cellWillAppear()
        self.myItem = self.item as! ZJPictureTableItem
        self.layout.itemSize = self.myItem.pictureSize!;
        self.layout.minimumInteritemSpacing = self.myItem.space;
        self.layout.minimumLineSpacing = self.myItem.space;
        //-8是因为图片本身布局就和右边距离8像素
        if let edge = myItem.customEdgeInsets {
            self.collectionView.contentInset = edge
        }else{
            self.collectionView.contentInset = UIEdgeInsetsMake(0, self.myItem.space, self.myItem.space, self.myItem.space);
        }

        self.collectionView.reloadData()
        
    }
    
    
    func deletePicture(vc: UIViewController?, index: Int,  complete: (() -> Void)?) {
        let alertVC = UIAlertController(title: "提示", message: "确定删除此附件吗？", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "确定", style: .destructive) { [weak self] (action) in
            if (self?.isDisplayAddButton())! {
                self?.myItem.arrPictures.remove(at: index)
                self?.collectionView.reloadData()
            }else{
                self?.myItem.arrPictures.remove(at: index)
                self?.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            self?.myItem.updateHeight()
            
            if let handler = complete {
                handler()
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alertVC.addAction(confirm)
        alertVC.addAction(cancel)
        if let superVC = vc {
            superVC.present(alertVC, animated: true, completion: nil)
        }else{
            myItem.superVC.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func isDisplayAddButton() -> Bool {
        return self.myItem.arrPictures.count == Int(self.myItem.maxNumber)
    }
    
    func showImage(index: Int, isShowDelete: Bool) {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
        
        var images = [SKPhoto]()
        for image in myItem.arrPictures {
            var photo: SKPhoto!
            if (image as AnyObject).isKind(of: UIImage.self) {
                photo = SKPhoto.photoWithImage(image as! UIImage)
            }
            
            images.append(photo)
            photo.shouldCachePhotoURLImage = false
        }
        SKPhotoBrowserOptions.displayDeleteButton = isShowDelete
        SKPhotoBrowserOptions.displayStatusbar = true
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        let browser = SKPhotoBrowser(originImage: cell.img.image!, photos: images, animatedFromView: cell.img)
        browser.initializePageIndex(index)
        browser.delegate = self as SKPhotoBrowserDelegate
        self.myItem.superVC.present(browser, animated: true, completion: {})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - CollectionViewDelegate

extension ZJPictureTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.myItem.type {
        case .read://只是展示图片，返回图片数量
            return self.myItem.arrPictures.count
        case .edit:
            //如果是编辑状态，图片数量满了，就不显示添加按钮
            if self.myItem.arrPictures.count == Int(self.myItem.maxNumber) {
                return self.myItem.arrPictures.count
            }else{
                //图片数量没有满，显示添加按钮（+1)
                return self.myItem.arrPictures.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZJPictureCollectionCell", for: indexPath) as! ZJPictureCollectionCell
        cell.collectionView = self.collectionView
        switch self.myItem.type {
        case .read://只是展示图片
            cell.btnDelete.isHidden = true
            cell.config(imageModel: myItem.arrPictures[indexPath.item])
        case .edit:
            cell.btnDelete.isHidden = false
            //如果是编辑状态，图片数量满了，就不显示添加按钮
            if self.myItem.arrPictures.count == indexPath.item {
                cell.btnDelete.isHidden = true
                cell.img.image = #imageLiteral(resourceName: "picture_add")
            }else{
                cell.config(imageModel: myItem.arrPictures[indexPath.item])
            }
        }
        
        weak var weakSelf = self
        cell.setDeleteHandler { (currentIndex) in
            weakSelf?.deletePicture(vc: nil, index: currentIndex, complete: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.myItem.type {
        case .read:
            print("查看图片")
            self.showImage(index: indexPath.item, isShowDelete: false)
        case .edit:
            if self.myItem.arrPictures.count == indexPath.item {
                print("添加图片")
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.imageLimit = Int(self.myItem.maxNumber - CGFloat(self.myItem.arrPictures.count))
                self.myItem.superVC.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("查看图片，可删除")
                self.showImage(index: indexPath.item, isShowDelete: true)
            }
        }
    }
}

// MARK: - 拍照
extension ZJPictureTableCell: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            myItem.arrPictures.append(image)
        }
        myItem.updateHeight()
        self.collectionView.reloadData()
        myItem.superVC.dismiss(animated: true, completion: nil)
    }
    
    //完成选择图片
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            myItem.arrPictures.append(image)
        }
        myItem.updateHeight()
        self.collectionView.reloadData()
        myItem.superVC.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.myItem.superVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 拍照
extension ZJPictureTableCell: SKPhotoBrowserDelegate {
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        self.deletePicture(vc: browser, index: index) {
            reload()
        }
    }
    
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
        return cell.img
    }
   
}
