//
//  CustomRowCell.swift
//  NestedSections
//
//  Created by arindam_ghosh on 12/13/16.
//  Copyright © 2016 arindam_ghosh. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel{

    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor?{
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable public var bottomInset: CGFloat {
        get { return touchPadding.bottom }
        set { touchPadding.bottom = newValue }
    }
    @IBInspectable public var leftInset: CGFloat {
        get { return touchPadding.left }
        set { touchPadding.left = newValue }
    }
    @IBInspectable public var rightInset: CGFloat {
        get { return touchPadding.right }
        set { touchPadding.right = newValue }
    }
    @IBInspectable public var topInset: CGFloat {
        get { return touchPadding.top }
        set { touchPadding.top = newValue }
    }
    public var touchPadding : UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

class CustomRowCell: UITableViewCell {

    @IBOutlet weak var titleCell: CustomLabel!
    @IBOutlet weak var seperatorLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



