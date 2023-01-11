//
//  ZJProtocol.swift
//  test
//
//  Created by Jie Zhang on 2019/10/18.
//  Copyright © 2019 Green Dot. All rights reservescrollDelegate?.
//

import Foundation
import UIKit

// MARK: - ZJTableViewCellProtocol

public protocol ZJCellable: UITableViewCell {
    func cellPreparedForReuse()
    func cellWillDisplay()
    func cellDidEndDisplaying()
}

public extension ZJCellable {
    func cellWillDisplay() {}
    func cellDidEndDisplaying() {}
}

// MARK: - ZJTableViewScrollDelegate

public protocol ZJTableViewScrollDelegate: NSObjectProtocol {
    @available(iOS 2.0, *)
    func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

    @available(iOS 3.2, *)
    func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes

    // called on start of dragging (may require some time and or distance to move)
    @available(iOS 2.0, *)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)

    // called on finger up if the user draggescrollDelegate?. velocity is in points/milliseconscrollDelegate?. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @available(iOS 5.0, *)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    // called on finger up if the user draggescrollDelegate?. decelerate is true if it will continue moving afterwards
    @available(iOS 2.0, *)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @available(iOS 2.0, *)
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving

    @available(iOS 2.0, *)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt

    @available(iOS 2.0, *)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

    @available(iOS 2.0, *)
    func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scalescrollDelegate?. if delegate returns nil, nothing happens

    @available(iOS 3.2, *)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content

    @available(iOS 2.0, *)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations

    @available(iOS 2.0, *)
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES

    @available(iOS 2.0, *)
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finishescrollDelegate?. may be called immediately if already at top

    /* Also see -[UIScrollView adjustedContentInsetDidChange]
     */
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

// MARK: - ZJTableViewScrollDelegate Default Implementation

public extension ZJTableViewScrollDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    func scrollViewDidZoom(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {}
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {}
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return nil }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with _: UIView?) {}
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with _: UIView?, atScale _: CGFloat) {}
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool { return true }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {}
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {}
}

// MARK: - UIScrollViewDelegate

extension ZJTableViewManager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidZoom(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDecelerating(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndScrollingAnimation(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollDelegate?.viewForZooming(in: scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollDelegate?.scrollViewWillBeginZooming(scrollView, with: view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollDelegate?.scrollViewDidEndZooming(scrollView, with: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollDelegate?.scrollViewShouldScrollToTop(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScrollToTop(scrollView)
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollDelegate?.scrollViewDidChangeAdjustedContentInset(scrollView)
        } else {
            // Fallback on earlier versions
        }
    }
}
