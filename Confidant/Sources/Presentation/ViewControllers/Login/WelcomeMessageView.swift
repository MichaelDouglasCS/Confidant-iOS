//
//  WelcomeMessageView.swift
//  Confidant
//
//  Created by Michael Douglas on 05/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

fileprivate let nibName = "WelcomeMessageView"

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

@IBDesignable class WelcomeMessageView: UIView {

    //*************************************************
    // MARK: - IBOutlets
    //*************************************************

    @IBOutlet weak var welcomeMessageTitle: IBDesigableLabel!
    @IBOutlet weak var welcomeMessageText: IBDesigableLabel!

    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    private var messageView: UIView!
    
    @IBInspectable var messageTitle: String? {
        get {
            return self.welcomeMessageTitle.text
        }
        set(messageTitle) {
            self.welcomeMessageTitle.text = messageTitle
        }
    }
    
    @IBInspectable var messageText: String? {
        get {
            return self.welcomeMessageText.text
        }
        set(messageText) {
            self.welcomeMessageText.text = messageText
        }
    }
        
    //*************************************************
    // MARK: - Constructors
    //*************************************************
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func setup() {
        self.messageView = loadViewFromNib()
        self.messageView.backgroundColor = UIColor.clear
        self.messageView.frame = self.bounds
        self.messageView .autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.messageView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
}
