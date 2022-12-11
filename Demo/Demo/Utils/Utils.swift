//
//  Utils.swift
//  Demo
//
//  Created by Jie Zhang on 2022/12/10.
//

import Foundation
import UIKit

extension UIApplication {
    
    func getKeyWindow() -> UIWindow {
        return keyWindow ?? windows.first(where: {$0.isKeyWindow})!
    }
}

extension UIViewController {
    func addFPS() {
        let fpsLabel = YYFPSLabel()
        let keyWindow = (UIApplication.shared.keyWindow)!
        let x = keyWindow.frame.width - fpsLabel.frame.width - 4
        let y = UIApplication.shared.statusBarFrame.height + 52
        fpsLabel.frame = CGRect(x: x, y: y, width: fpsLabel.frame.width, height: fpsLabel.frame.height)
        keyWindow.addSubview(fpsLabel)
    }
}


/// 假装调用接口
/// - Parameters:
///   - view: 展示indicator的view
///   - callBack: 模拟网络请求完成之后的回调
func mockHttpRequest(view: UIView, callBack: (() -> Void)?) {
    let shadowView = UIView(frame: view.bounds)
    shadowView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.addSubview(shadowView)

    #if swift(>=4.2)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
    #else
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    #endif

    indicator.center = shadowView.center

    shadowView.addSubview(indicator)
    indicator.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        shadowView.removeFromSuperview()

        callBack?()
    }
}
