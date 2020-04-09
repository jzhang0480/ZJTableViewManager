//
//  FPSStatusBarViewController.swift
//  fps-counter
//
//  Created by Markus Gasser on 04.03.16.
//  Copyright © 2016 konoma GmbH. All rights reserved.
//

import UIKit

/// A view controller to show a FPS label in the status bar.
///
class FPSStatusBarViewController: UIViewController {
    fileprivate let fpsCounter = FPSCounter()
    private let label = UILabel()

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        commonInit()
    }

    private func commonInit() {
        #if swift(>=4.2)
            NotificationCenter.default.addObserver(self,
            selector: #selector(FPSStatusBarViewController.updateStatusBarFrame(_:)),
            name: UIApplication.didChangeStatusBarOrientationNotification,
            object: nil)
        #else
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FPSStatusBarViewController.updateStatusBarFrame(_:)),
                                               name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
            
        
        #endif
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View Lifecycle and Events

    override func loadView() {
        view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))

        let font = UIFont.boldSystemFont(ofSize: 10.0)
        let rect = view.bounds.insetBy(dx: 10.0, dy: 0.0)

        label.frame = CGRect(x: rect.origin.x, y: rect.maxY - font.lineHeight - 1.0, width: rect.width, height: font.lineHeight)
        label.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        label.font = font
        view.addSubview(label)

        fpsCounter.delegate = self
    }

    @objc func updateStatusBarFrame(_ notification: Notification) {
        let application = notification.object as? UIApplication
        let frame = CGRect(x: 0.0, y: 0.0, width: application?.keyWindow?.bounds.width ?? 0.0, height: 20.0)

        FPSStatusBarViewController.statusBarWindow.frame = frame
    }

    // MARK: - Getting the shared status bar window

    @objc static var statusBarWindow: UIWindow = {
        let window = FPStatusBarWindow()
        #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.statusBar
            
        #else
        window.windowLevel = UIWindowLevelStatusBar
        #endif
        window.rootViewController = FPSStatusBarViewController()
        return window
    }()
}

// MARK: - FPSCounterDelegate

extension FPSStatusBarViewController: FPSCounterDelegate {
    @objc func fpsCounter(_: FPSCounter, didUpdateFramesPerSecond fps: Int) {
        resignKeyWindowIfNeeded()

        let milliseconds = 1000 / max(fps, 1)
        label.text = "\(fps) FPS (\(milliseconds) milliseconds per frame)"

        switch fps {
        case 45...:
            view.backgroundColor = .green
            label.textColor = .black
        case 35...:
            view.backgroundColor = .orange
            label.textColor = .white
        default:
            view.backgroundColor = .red
            label.textColor = .white
        }
    }

    private func resignKeyWindowIfNeeded() {
        // prevent the status bar window from becoming the key window and steal events
        // from the main application window
        if FPSStatusBarViewController.statusBarWindow.isKeyWindow {
            UIApplication.shared.delegate?.window??.makeKey()
        }
    }
}

public extension FPSCounter {
    // MARK: - Show FPS in the status bar

    /// Add a label in the status bar that shows the applications current FPS.
    ///
    /// - Note:
    ///   Only do this in debug builds. Apple may reject your app if it covers the status bar.
    ///
    /// - Parameters:
    ///   - application: The `UIApplication` to show the FPS for
    ///   - runloop:     The `NSRunLoop` to use when tracking FPS. Default is the main run loop
    ///   - mode:        The run loop mode to use when tracking. Default uses `RunLoop.Mode.common`
    ///
    #if swift(>=4.2)
        @objc class func showInStatusBar(
            application: UIApplication = .shared,
            runloop: RunLoop = .main,
            mode: RunLoop.Mode = RunLoop.Mode.common
        ) {
            let window = FPSStatusBarViewController.statusBarWindow
            window.frame = application.statusBarFrame
            window.isHidden = false

            if let controller = window.rootViewController as? FPSStatusBarViewController {
                controller.fpsCounter.startTracking(
                    inRunLoop: runloop,
                    mode: mode
                )
            }
        }
    #else
        @objc class func showInStatusBar(
            application: UIApplication = .shared,
            runloop: RunLoop = .main,
            mode: RunLoop.Mode = RunLoopMode.commonModes
        ) {
            let window = FPSStatusBarViewController.statusBarWindow
            window.frame = application.statusBarFrame
            window.isHidden = false

            if let controller = window.rootViewController as? FPSStatusBarViewController {
                controller.fpsCounter.startTracking(
                    inRunLoop: runloop,
                    mode: mode
                )
            }
        }
        
    #endif

    /// Removes the label that shows the current FPS from the status bar.
    ///
    @objc class func hide() {
        let window = FPSStatusBarViewController.statusBarWindow

        if let controller = window.rootViewController as? FPSStatusBarViewController {
            controller.fpsCounter.stopTracking()
            window.isHidden = true
        }
    }

    /// Returns wether the FPS counter is currently visible or not.
    ///
    @objc class var isVisible: Bool {
        return !FPSStatusBarViewController.statusBarWindow.isHidden
    }
}
