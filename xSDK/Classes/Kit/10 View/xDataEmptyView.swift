//
//  xDataEmptyView.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xDataEmptyView: xView {
    
    // MARK: - Public Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Func
    public class func loadNib() -> xDataEmptyView {
        let bundle = Bundle.init(for: self.classForCoder())
        let arr = bundle.loadNibNamed("xDataEmptyView", owner: nil, options: nil)!
        let view = arr.first! as! xDataEmptyView
        return view
    }

}
