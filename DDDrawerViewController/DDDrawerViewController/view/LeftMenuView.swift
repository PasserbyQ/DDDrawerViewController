//
//  LeftMenuView.swift
//  DDDrawerViewController
//
//  Created by yu qin on 2019/7/31.
//  Copyright © 2019 yu qin. All rights reserved.
//

import UIKit

protocol LeftMenuViewDelegate {
    // 消失
    func dismiss()

}


class LeftMenuView: UIView {

    
    var delegate: LeftMenuViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        if let d = delegate {
            d.dismiss()
        }
    }
    
}

extension LeftMenuView {
    class func leftView() -> LeftMenuView {
        return Bundle.main.loadNibNamed("LeftMenuView", owner: self, options: nil)?.first as! LeftMenuView
    }
    
}


