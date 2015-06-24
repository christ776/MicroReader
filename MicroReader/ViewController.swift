//
//  ViewController.swift
//  MicroReader
//
//  Created by Christian De Martino on 6/15/15.
//  Copyright (c) 2015 Christian De Martino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet var textViewContainer: PaginatedTextContainerView!
    
    private var topViewConstraintConstantBackup:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewConstraintConstantBackup = topViewConstraint.constant
        
        // Do any additional setup after loading the view, typically from a nib.
         if let contentURL = NSBundle.mainBundle().URLForResource("Latin-Lipsum",withExtension:"txt") {
            
            if let textStorage = NSTextStorage(fileURL: contentURL, options: nil, documentAttributes: nil, error: nil) {
                textViewContainer.textStorage = textStorage
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
       
        let transitionToWide = size.width > size.height
        if transitionToWide {
           self.topViewConstraint.constant = 0
        }
        else {
            self.topViewConstraint.constant = topViewConstraintConstantBackup
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            self.textViewContainer.setNeedsDisplay()
        }
    }
}

