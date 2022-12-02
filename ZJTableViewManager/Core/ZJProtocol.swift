//
//  ZJProtocol.swift
//  test
//
//  Created by Jie Zhang on 2019/10/18.
//  Copyright © 2019 Green Dot. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ZJTableViewCellProtocol

public protocol ZJItemProtocol where Self: ZJTableViewItem {}

public protocol ZJInternalCellProtocol where Self: UITableViewCell {
    var _item: ZJItemProtocol? { get set }
    func cellPrepared()
    func cellWillAppear()
    func cellDidAppear()
    func cellDidDisappear()
}

public extension ZJInternalCellProtocol {
    func cellWillAppear() {}
    func cellDidAppear() {}
    func cellDidDisappear() {}
}

public protocol ZJCellProtocol: ZJInternalCellProtocol {
    associatedtype ZJCellItemClass: ZJItemProtocol
    var item: ZJCellItemClass! { get set }
}

public extension ZJCellProtocol {
    var _item: ZJItemProtocol? {
        get {
            return item
        }
        set {
            item = (newValue as! Self.ZJCellItemClass)
        }
    }
}

extension ZJTableViewItem: ZJItemProtocol {}

// MARK: - ZJTableViewScrollDelegate

public protocol ZJTableViewScrollDelegate: NSObjectProtocol {
    @available(iOS 2.0, *)
    func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

    @available(iOS 3.2, *)
    func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes

    // called on start of dragging (may require some time and or distance to move)
    @available(iOS 2.0, *)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)

    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @available(iOS 5.0, *)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @available(iOS 2.0, *)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @available(iOS 2.0, *)
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving

    @available(iOS 2.0, *)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt

    @available(iOS 2.0, *)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

    @available(iOS 2.0, *)
    func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens

    @available(iOS 3.2, *)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content

    @available(iOS 2.0, *)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations

    @available(iOS 2.0, *)
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES

    @available(iOS 2.0, *)
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top

    /* Also see -[UIScrollView adjustedContentInsetDidChange]
     */
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

// MARK: - ZJTableViewScrollDelegate Default Implementation

public extension ZJTableViewScrollDelegate {
    func scrollViewDidScroll(_: UIScrollView) {}

    func scrollViewDidZoom(_: UIScrollView) {}

    func scrollViewWillBeginDragging(_: UIScrollView) {}

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {}

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) {}

    func scrollViewWillBeginDecelerating(_: UIScrollView) {}

    func scrollViewDidEndDecelerating(_: UIScrollView) {}

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {}

    func viewForZooming(in _: UIScrollView) -> UIView? { return nil }

    func scrollViewWillBeginZooming(_: UIScrollView, with _: UIView?) {}

    func scrollViewDidEndZooming(_: UIScrollView, with _: UIView?, atScale _: CGFloat) {}

    func scrollViewShouldScrollToTop(_: UIScrollView) -> Bool { return true }

    func scrollViewDidScrollToTop(_: UIScrollView) {}

    func scrollViewDidChangeAdjustedContentInset(_: UIScrollView) {}
}

// MARK: - UIScrollViewDelegate

extension ZJTableViewManager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidScroll(scrollView)
        }
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidZoom(scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginDragging(scrollView)
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let d = scrollDelegate {
            d.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let d = scrollDelegate {
            d.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        }
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidEndDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidEndScrollingAnimation(scrollView)
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let d = scrollDelegate {
            return d.viewForZooming(in: scrollView)
        }
        return nil
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginZooming(scrollView, with: view)
        }
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let d = scrollDelegate {
            d.scrollViewDidEndZooming(scrollView, with: view, atScale: scale)
        }
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let d = scrollDelegate {
            return d.scrollViewShouldScrollToTop(scrollView)
        }
        return true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidScrollToTop(scrollView)
        }
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            if #available(iOS 11.0, *) {
                d.scrollViewDidChangeAdjustedContentInset(scrollView)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
