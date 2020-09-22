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
    /// 图片链接
    var pictureUrl = ""
    
    // MARK: - 内存释放
    deinit {
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("🥚_PVC \(name)")
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.pictureUrl.hasPrefix("http") {
            self.imgIcon.sd_setImage(with: self.pictureUrl.x_toURL(), completed: nil)
        }
        else {
            if let img = UIImage.init(named: self.pictureUrl) {
                self.imgIcon.image = img
            }
            else {
                let bundle = Bundle.init(for: self.classForCoder)
                self.imgIcon.image = UIImage.init(named: self.pictureUrl, in: bundle, compatibleWith: nil)
            }
        }
    }

}
