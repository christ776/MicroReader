//
//  ViewController.swift
//  MicroReader
//
//  Created by Christian De Martino on 6/15/15.
//  Copyright (c) 2015 Christian De Martino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textViewContainer: PaginatedTextContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         if let contentURL = NSBundle.mainBundle().URLForResource("Latin-Lipsum",withExtension:"txt") {
            
            if let textStorage = NSTextStorage(fileURL: contentURL, options: nil, documentAttributes: nil, error: nil) {
                textViewContainer.textStorage = textStorage
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        //textViewContainer.layoutIfNeeded()
        textViewContainer.setNeedsDisplay()
    }
}

