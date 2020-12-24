//
//  xDefaultOnePageItemViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/21.
//

import UIKit
import SDWebImage

class xDefaultOnePageItemViewController: xViewController {

    // MARK: - IBOutlet Property
    /// 图片
    @IBOutlet weak var imgIcon: xImageView!

    // MARK: - Public Property
    /// 网络图片
    var webImage = ""
    /// 本地图片
    var locImage : UIImage?
    
    // MARK: - 内存释放
    deinit {
        xLog("🥚_PVC \(self.xClassStruct.name)")
    }
    
    // MARK: - Override Func
    override class func quickInstancetype() -> Self {
        let bundle = Bundle.init(for: self.classForCoder())
        let vc = xDefaultOnePageItemViewController.init(nibName: "xDefaultOnePageItemViewController", bundle: bundle)
        return vc as! Self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func addKit() {
        if let img = self.locImage {
            self.imgIcon.image = img
        }
        else {
            self.imgIcon.xSetWebImage(url: self.webImage)
        }
    }

}
