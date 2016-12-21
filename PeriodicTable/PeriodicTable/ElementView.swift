//
//  ElementView.swift
//  PeriodicTable
//
//  Created by Annie Tung on 12/21/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class ElementView: UIView {

    @IBOutlet weak var elementSymbol: UILabel!
    @IBOutlet weak var elementNumber: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // add to view hiearchy, embedding nib onto view
        if let view = Bundle.main.loadNibNamed("ElementView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
            //view.backgroundColor = .clear
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
