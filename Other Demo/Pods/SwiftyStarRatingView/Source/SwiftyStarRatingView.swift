//
//  SwiftyStarRatingView.swift
//  SwiftyStarRatingView
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

public typealias SSRVShouldBeginGesRecBlock = (_ gesture: UIGestureRecognizer) -> Bool

@IBDesignable
public class SwiftyStarRatingView: UIControl {
    @IBInspectable public var maximumValue: CGFloat {
        set {
            if _maximumValue != newValue {
                _maximumValue = newValue
                setNeedsDisplay()
            }
        }
        get {
            return max(_maximumValue, _minimumValue)
        }
    }

    @IBInspectable public var minimumValue: CGFloat {
        set {
            if _minimumValue != newValue {
                _minimumValue = newValue
                setNeedsDisplay()
            }
        }
        get {
            return max(_minimumValue, 0)
        }
    }

    @IBInspectable public var value: CGFloat {
        set {
            if _value != newValue {
                _value = newValue
            }
        }
        get {
            return min(max(_value, _minimumValue), _maximumValue)
        }
    }

    @IBInspectable public var spacing: CGFloat = 5 {
        didSet {
            if spacing != oldValue {
                setNeedsDisplay()
            }
        }
    }

    @IBInspectable public var allowsHalfStars: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var accurateHalfStars: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var continuous: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var emptyStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var halfStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var filledStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    public var shouldBecomeFirstResponder: Bool = false
    public var shouldBeginGesRecBlock: SSRVShouldBeginGesRecBlock!

    fileprivate var _minimumValue: CGFloat!
    fileprivate var _maximumValue: CGFloat!

    fileprivate var shouldUseImages: Bool {
        return (emptyStarImage != nil && filledStarImage != nil)
    }

    fileprivate var _value: CGFloat = 0 {
        didSet {
            if _value != oldValue && _value >= _minimumValue && _value <= _maximumValue && continuous == true {
                self.sendActions(for: .valueChanged)
            }
            setNeedsDisplay()
        }
    }

    override public var isEnabled: Bool {
        willSet {
            updateAppearance(enabled: newValue)
        }
    }

    override public var canBecomeFirstResponder: Bool {
        return shouldBecomeFirstResponder
    }

    override public var intrinsicContentSize: CGSize {
        let height: CGFloat = 44.0
        return CGSize(width: _maximumValue * height + (_maximumValue - 1) * spacing, height: height)
    }

    override public var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            setNeedsDisplay()
        }
        get {
            return super.tintColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor((backgroundColor?.cgColor ?? UIColor.white.cgColor)!)
        context?.fill(rect)

        let availableWidth = rect.width - 2 - (spacing * (_maximumValue - 1))
        let cellWidth = availableWidth / _maximumValue
        let starSide = (cellWidth <= rect.height) ? cellWidth : rect.height

        for idx in 0 ..< Int(_maximumValue) {
            let center = CGPoint(x: (cellWidth + spacing) * CGFloat(idx) + cellWidth / 2 + 1, y: rect.size.height / 2)
            let frame = CGRect(x: center.x - starSide / 2, y: center.y - starSide / 2, width: starSide, height: starSide)
            let highlighted = (Float(idx + 1) <= ceilf(Float(_value)))

            if allowsHalfStars && highlighted && (CGFloat(idx + 1) > _value) {
                if accurateHalfStars {
                    drawAccurateStar(frame: frame, tintColor: tintColor, progress: _value - CGFloat(idx))
                } else {
                    drawHalfStar(frame: frame, tintColor: tintColor)
                }
            } else {
                drawStar(frame: frame, tintColor: tintColor, highlighted: highlighted)
            }
        }
    }
}

private extension SwiftyStarRatingView {
    func customInit() {
        _value = 0
        spacing = 0.0
        continuous = true
        _minimumValue = 0
        _maximumValue = 5
        isExclusiveTouch = true
        updateAppearance(enabled: isEnabled)
    }

    func drawStar(frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        if shouldUseImages {
            drawStartImage(frame: frame, tintColor: tintColor, highlighted: highlighted)
        } else {
            drawStarShape(frame: frame, tintColor: tintColor, highlighted: highlighted)
        }
    }

    func drawHalfStar(frame: CGRect, tintColor: UIColor) {
        if shouldUseImages {
            drawHalfStarImage(frame: frame, tintColor: tintColor)
        } else {
            drawHalfStarShape(frame: frame, tintColor: tintColor)
        }
    }

    func drawAccurateStar(frame: CGRect, tintColor: UIColor, progress: CGFloat) {
        if shouldUseImages {
            drawAccurateHalfStarImage(frame: frame, tintColor: tintColor, progress: progress)
        } else {
            drawAccurateHalfStarShape(frame: frame, tintColor: tintColor, progress: progress)
        }
    }

    func updateAppearance(enabled: Bool) {
        alpha = enabled ? 1.0 : 1.5
    }
}

private extension SwiftyStarRatingView {
    // Image Drawing
    func drawStartImage(frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        let image = highlighted ? filledStarImage : emptyStarImage
        draw(image: image!, frame: frame, tintColor: tintColor)
    }

    func drawHalfStarImage(frame: CGRect, tintColor: UIColor) {
        drawAccurateHalfStarImage(frame: frame, tintColor: tintColor, progress: 0.5)
    }

    func drawAccurateHalfStarImage(frame: CGRect, tintColor: UIColor, progress: CGFloat) {
        var image = halfStarImage
        var aFrame = frame
        if image == nil {
            let imageF = CGRect(x: 0, y: 0, width: (image?.size.width)! * (image?.scale)! * progress, height: (image?.size.height)! * (image?.scale)!)
            aFrame.size.width *= progress
            let imageRef = (image?.cgImage)!.cropping(to: imageF)
            let halfImage = UIImage(cgImage: imageRef!, scale: (image?.scale)!, orientation: (image?.imageOrientation)!)
            image = halfImage.withRenderingMode((image?.renderingMode)!)
        }
        draw(image: image!, frame: aFrame, tintColor: tintColor)
    }

    func draw(image: UIImage, frame: CGRect, tintColor: UIColor) {
        if image.renderingMode == .alwaysTemplate {
            tintColor.setFill()
        }
        image.draw(in: frame)
    }
}

private extension SwiftyStarRatingView {
    // Shape Drawing
    func drawStarShape(frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        drawAccurateHalfStarShape(frame: frame, tintColor: tintColor, progress: highlighted ? 1.0 : 0.0)
    }

    func drawHalfStarShape(frame: CGRect, tintColor: UIColor) {
        drawAccurateHalfStarShape(frame: frame, tintColor: tintColor, progress: 0.5)
    }

    func drawAccurateHalfStarShape(frame: CGRect, tintColor: UIColor, progress: CGFloat) {
        let starShapePath = UIBezierPath()
        starShapePath.move(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.02500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.37292 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.02500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.30504 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.20642 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.78265 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.79358 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.69501 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.97500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.close()
        starShapePath.miterLimit = 4

        let frameWidth = frame.size.width
        let rightRectOfStar = CGRect(x: frame.origin.x + progress * frameWidth, y: frame.origin.y, width: frameWidth - progress * frameWidth, height: frame.size.height)

        let clipPath = UIBezierPath(rect: CGRect.infinite)
        clipPath.append(UIBezierPath(rect: rightRectOfStar))
        clipPath.usesEvenOddFillRule = true

        UIGraphicsGetCurrentContext()!.saveGState()
        clipPath.addClip()
        tintColor.setFill()
        starShapePath.fill()
        UIGraphicsGetCurrentContext()!.restoreGState()

        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()
    }
}

public extension SwiftyStarRatingView {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.beginTracking(touch, with: event)
            if shouldBecomeFirstResponder && !isFirstResponder {
                becomeFirstResponder()
            }
            handle(touch: touch)
            return true
        } else {
            return false
        }
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.continueTracking(touch, with: event)
            handle(touch: touch)
            return true
        } else {
            return false
        }
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if shouldBecomeFirstResponder && isFirstResponder {
            resignFirstResponder()
        }
        handle(touch: touch!)
        if !continuous {
            sendActions(for: .valueChanged)
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        if shouldBecomeFirstResponder && isFirstResponder {
            resignFirstResponder()
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view?.isEqual(self))! {
            return !isUserInteractionEnabled
        } else {
            return (shouldBeginGesRecBlock != nil) ? shouldBeginGesRecBlock(gestureRecognizer) : false
        }
    }

    private func handle(touch: UITouch) {
        let cellWidth = bounds.width / _maximumValue
        let location = touch.location(in: self)
        var aValue = location.x / cellWidth
        if allowsHalfStars {
            if accurateHalfStars {
            } else {
                if aValue + 0.5 < ceil(aValue) {
                    aValue = floor(aValue) + 0.5
                } else {
                    aValue = ceil(aValue)
                }
            }
        } else {
            aValue = ceil(aValue)
        }
        if aValue < minimumValue {
            value = minimumValue
        } else {
            value = aValue
        }
    }
}

public extension SwiftyStarRatingView {
    override func accessibilityActivate() -> Bool {
        return true
    }

    override func accessibilityIncrement() {
        let aValue = _value + (allowsHalfStars ? 0.5 : 1.0)
        value = aValue
    }

    override func accessibilityDecrement() {
        let aValue = _value - (allowsHalfStars ? 0.5 : 1.0)
        value = aValue
    }
}
