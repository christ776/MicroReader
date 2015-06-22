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
    
    private func renderTextStorage() {
        
        var textContainerSize = CGSizeMake(self.bounds.width / CGFloat(self.columns), self.bounds.height)
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
                    //textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                    addImageInTextContainer(textContainer,textView: textView)
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
    
    private func setUpColumns() {
        
        for index in 1...columns {
            
            let textContainer = NSTextContainer()
            self.layoutManager.addTextContainer(textContainer)
            let textView = UITextView(frame: CGRectZero, textContainer: textContainer)
            textView.text = "Hello !!"
            textView.setTranslatesAutoresizingMaskIntoConstraints(false)
            textView.scrollEnabled = false
      
            self.scrollView.addSubview(textView)
            textViews.append(textView)
        }
        self.setNeedsUpdateConstraints()
    }
    
    private func setUpConstraints() {
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        var constraints = [NSLayoutConstraint]()

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        renderTextStorage()
//    }
    
    override func updateConstraints() {
        setUpConstraints()
        super.updateConstraints()
    }
    
    
    override func drawRect(rect: CGRect) {
        renderTextStorage()
    }
}
