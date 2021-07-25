//
//  ZJTextView.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

class ZJTextView: UITextView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        #if swift(>=4.2)
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
        #else
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        #endif
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        #if swift(>=4.2)
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
        #else
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        #endif
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        #if swift(>=4.2)
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
        #else
            NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaceholder), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        #endif
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate var placeholderLabel: UILabel?

    /** @abstract To set textView's placeholder text. Default is ni.    */
    @IBInspectable open var placeholder: String? {
        get {
            return placeholderLabel?.text
        }

        set {
            if placeholderLabel == nil {
                placeholderLabel = UILabel()

                if let unwrappedPlaceholderLabel = placeholderLabel {
                    unwrappedPlaceholderLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    unwrappedPlaceholderLabel.lineBreakMode = .byWordWrapping
                    unwrappedPlaceholderLabel.numberOfLines = 0
                    unwrappedPlaceholderLabel.font = self.font
                    unwrappedPlaceholderLabel.textAlignment = self.textAlignment
                    unwrappedPlaceholderLabel.backgroundColor = UIColor.clear
                    unwrappedPlaceholderLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
                    unwrappedPlaceholderLabel.alpha = 0
                    addSubview(unwrappedPlaceholderLabel)
                }
            }

            placeholderLabel?.text = newValue
            refreshPlaceholder()
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if let unwrappedPlaceholderLabel = placeholderLabel {
            let offsetLeft = textContainerInset.left + textContainer.lineFragmentPadding
            let offsetRight = textContainerInset.right + textContainer.lineFragmentPadding
            let offsetTop = textContainerInset.top
            let offsetBottom = textContainerInset.top

            let expectedSize = unwrappedPlaceholderLabel.sizeThatFits(CGSize(width: frame.width - offsetLeft - offsetRight, height: frame.height - offsetTop - offsetBottom))

            unwrappedPlaceholderLabel.frame = CGRect(x: offsetLeft, y: offsetTop, width: expectedSize.width, height: expectedSize.height)
        }
    }

    @objc open func refreshPlaceholder() {
        if !text.isEmpty {
            placeholderLabel?.alpha = 0
        } else {
            placeholderLabel?.alpha = 1
        }
    }

    override open var text: String! {
        didSet {
            refreshPlaceholder()
        }
    }

    override open var font: UIFont? {
        didSet {
            if let unwrappedFont = font {
                placeholderLabel?.font = unwrappedFont
            } else {
                placeholderLabel?.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel?.textAlignment = textAlignment
        }
    }

    override open var delegate: UITextViewDelegate? {
        get {
            refreshPlaceholder()
            return super.delegate
        }

        set {
            super.delegate = newValue
        }
    }
}
