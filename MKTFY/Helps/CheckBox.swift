//
//  CheckBox+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/14.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = UIImage(named: "check_box_filled")! as UIImage
    let uncheckedImage = UIImage(named: "check_box_empty")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
            
            self.sendActions(for: .valueChanged)
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
