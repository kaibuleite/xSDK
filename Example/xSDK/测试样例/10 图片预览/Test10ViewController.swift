//
//  Test10ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test10ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func normalBtnClick() {
        var arr = [UIImage]()
        for i in 1 ... 9 {
            let name = "IMG_\(i)"
            guard let img = UIImage.init(named: name) else { continue }
            arr.append(img)
        }
        guard arr.count > 0 else { return }
        xPreviewImagesViewController.display(from: self, images: arr, index: 0)
    }
    
    @IBAction func gifBtnClick() {
        var arr = [Data]()
        for i in 1 ... 5 {
            let name = "PIC_\(i)"
            let path = Bundle.main.path(forResource: name, ofType: "gif")!
            let data = NSData.init(contentsOfFile: path)!
            arr.append(data as Data)
        }
        guard arr.count > 0 else { return }
        xPreviewImagesViewController.display(from: self, datas: arr, index: 0)
    }
    
    @IBAction func netBtnClick() {
        let arr = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603366957146&di=ef695b00a650e0c8fe3dfe6d1b2fa34a&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171105%2F7ff147be1b564bb9a049f48f9b8fe336.gif",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603367500054&di=0c82f78d858ec9478013fb2af262d41a&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190111%2Fab563fb571db46f0896c0182925330df.gif",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603367510498&di=b5bae970c8e6313a895305f8283e6648&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170401%2F458f04d133a040339280add5f44286d5_th.gif",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603367524710&di=f157b1ec644bbb50ae39a01ab4ddc59a&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201607%2F15%2F20160715140507_VH2MQ.gif",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603367551382&di=01a3de522370a58b4b74f66e144ceece&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180418%2Fb4035de3c8424a6188f5fd1be533754e.gif",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603367566609&di=c0492d86c4f3061ff3ce089522711491&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F07%2F20150507204823_KLhUf.thumb.400_0.gif",]
        guard arr.count > 0 else { return }
        xPreviewImagesViewController.display(from: self, imageUrls: arr, index: 0)
    }
}
