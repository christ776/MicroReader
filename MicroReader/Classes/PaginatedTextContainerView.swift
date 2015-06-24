//
//  PaginatedTextContainerView.swift
//  MicroReader
//
//  Created by Christian De Martino on 6/16/15.
//  Copyright (c) 2015 Christian De Martino. All rights reserved.
//

import UIKit

class PaginatedTextContainerView: UIView {
    
    private var layoutManager:NSLayoutManager!
    private var scrollView:UIScrollView!
    
    private var columns:Int = 2
    
    private var textViews:[UITextView] = []
    
    convenience init(columns:Int, textStorage:NSTextStorage) {
        self.init(frame:CGRectZero)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.columns = columns
        self.textStorage = textStorage
        self.layoutManager = NSLayoutManager()
        setUpScrollView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layoutManager = NSLayoutManager()
        setUpScrollView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layoutManager = NSLayoutManager()
        setUpScrollView()
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    private func addImageInTextContainer (textContainer:NSTextContainer, textView:UITextView) {
        
        let  butterfly = UIImageView(image: UIImage(named: "250px-267Beautifly"))
        butterfly.frame = CGRectMake(0, 0, 125, 125)
        
        textView.addSubview(butterfly)
       
        // Simply set the exclusion path
        let bezierPath = UIBezierPath(roundedRect: butterfly.frame, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(10, 10))
        
        textContainer.exclusionPaths = [bezierPath]
    }
    
    private func putTextInisideCircularArea(textContainer:NSTextContainer) {
        
        var ratio:CGFloat = 0
        
        if textContainer.size.width > textContainer.size.height {
            ratio = textContainer.size.height
        }
        else {
            ratio = textContainer.size.width
        }
        
        let rect = CGRectMake(0, 0, ratio, ratio)
        
        let overlayPath = UIBezierPath(rect:rect)
     
        
        var smallerRect = CGRectMake(rect.origin.x, rect.origin.y, rect.width, rect.height)
        
        let bezierPath = UIBezierPath(roundedRect:smallerRect,cornerRadius:smallerRect.height / 2)
        
        overlayPath.appendPath(bezierPath)
        overlayPath.usesEvenOddFillRule = true
        overlayPath.fill()
        
        textContainer.exclusionPaths = [overlayPath]
    }
    
    private func renderTextStorage() {
        
        var textContainerSize = CGSizeMake(self.scrollView.bounds.width / CGFloat(self.columns), self.scrollView.bounds.height)
        var currentXOffset: CGFloat = 0
        var lastRenderedGlyph:Int = 0
        
        if textViews.isEmpty {
            
            while (lastRenderedGlyph < layoutManager.numberOfGlyphs) {
                
                println("lastRenderedGlyph is \(lastRenderedGlyph) and total number of Glyphs: \(layoutManager.numberOfGlyphs)")
                
                for index in 1...columns {
                    
                    let textContainer = NSTextContainer(size: textContainerSize)
                    self.layoutManager.addTextContainer(textContainer)
                    let textViewFrame = CGRectMake(currentXOffset, 0, textContainerSize.width, textContainerSize.height)
                    let textView = UITextView(frame:textViewFrame, textContainer: textContainer)
                    textView.textAlignment = NSTextAlignment.Justified
                    //textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                    //addImageInTextContainer(textContainer,textView: textView)
                    putTextInisideCircularArea(textContainer)
                    textView.scrollEnabled = false
                    
                    scrollView.addSubview(textView)
                    textViews.append(textView)
                    
                    currentXOffset += CGRectGetWidth(textViewFrame)
                }
                
                // And find the index of the glyph we've just rendered
                let lastTextContainer = layoutManager.textContainers.last as! NSTextContainer
                lastRenderedGlyph = NSMaxRange(layoutManager.glyphRangeForTextContainer(lastTextContainer))
            }
            
        }
        else {
            
            for textView in textViews {
                let textViewFrame = CGRectMake(currentXOffset, 0, textContainerSize.width, textContainerSize.height)
                textView.frame = textViewFrame
                  currentXOffset += CGRectGetWidth(textViewFrame);
            }
        }

        
        let contentSize = CGSizeMake(currentXOffset, CGRectGetHeight(scrollView.bounds))
        scrollView.contentSize = contentSize
    }
    
    var textStorage:NSTextStorage? {
        
        willSet (newtextStorage) {
            
            newtextStorage!.addLayoutManager(layoutManager)
            setNeedsDisplay()
        }
    }
    
    private func setUpScrollView() {
        
        self.scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        self.addSubview(self.scrollView)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    private func setUpConstraints() {
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        var constraints = [NSLayoutConstraint]()

    }
    
    override func updateConstraints() {
        setUpConstraints()
        super.updateConstraints()
    }
    
    
    override func drawRect(rect: CGRect) {
        renderTextStorage()
    }
}
