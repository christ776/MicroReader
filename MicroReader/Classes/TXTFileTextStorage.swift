//
//  TXTFileTextStorage.swift
//  MicroReader
//
//  Created by Christian De Martino on 6/16/15.
//  Copyright (c) 2015 Christian De Martino. All rights reserved.
//

import UIKit

class TXTFileTextStorage: NSTextStorage {
    
    private var concreteString:NSMutableAttributedString!
    
//    class func storage(textFileString txtFile:String) -> NSTextStorage? {
//        
//        // Import the content into a text storage object
//        if let contentURL = NSBundle.mainBundle().URLForResource(txtFile.stringByDeletingPathExtension,withExtension:"txt") {
//            
//            let documentText = NSMutableAttributedString(fileURL: contentURL, options: [NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType], documentAttributes: nil, error: nil)
////            self.concreteString = NSMutableAttributedString()
////            self.concreteString.appendAttributedString(documentText!)
//            return TXTFileTextStorage(fileURL: contentURL, options: [NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType], documentAttributes: nil, error: nil)
//            
//        }
//        return nil
//    }
    
    override init?(fileURL url: NSURL!, options: [NSObject : AnyObject]!, documentAttributes dict: AutoreleasingUnsafeMutablePointer<NSDictionary?>, error: NSErrorPointer) {
        
        // Import the content into a text storage object
            
        if let documentText = NSMutableAttributedString(fileURL: url, options: [NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType], documentAttributes: nil, error: nil) {
            self.concreteString = NSMutableAttributedString()
            self.concreteString.appendAttributedString(documentText)
            super.init(attributedString: documentText)
        }
        else {
            super.init()
            return nil
        }

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(attributedString attrStr: NSAttributedString) {
        super.init(attributedString: attrStr)
        self.concreteString.appendAttributedString(attrStr)
    }
    
    override init() {
        concreteString = NSMutableAttributedString()
        super.init()
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        concreteString.replaceCharactersInRange(range,withString:str)
        self.edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: count(str) - range.length)
    }

    override func setAttributes(attrs: [NSObject : AnyObject]?, range: NSRange) {
        concreteString.setAttributes(attrs,range:range)
        self.edited(NSTextStorageEditActions.EditedAttributes, range:range, changeInLength:0)
    }
    
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [NSObject : AnyObject] {
         return concreteString.attributesAtIndex(location,effectiveRange:range)
    }
    
    override var string: String {
     
        get {
                return concreteString.string
            }
    }
}
