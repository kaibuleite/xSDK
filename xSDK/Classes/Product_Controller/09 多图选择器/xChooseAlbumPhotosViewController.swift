//
//  xChooseAlbumPhotosViewController.swift
//  xSDK
//
//  Created by Mac on 2020/10/22.
//

import UIKit
import TZImagePickerController

public class xChooseAlbumPhotosViewController: TZImagePickerController {
    
    // MARK: - 内存释放
    deinit {
        xLog("📸 \(self.xClassStruct.name)")
    }
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xChooseAlbumPhotosViewController.init(maxImagesCount: 9, delegate: nil)
        return vc as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
    }
    
    // MARK: - Public Func
    public static func display(from viewController : UIViewController,
                               maxImagesCount : Int,
                               completed handler : @escaping ([UIImage], [PHAsset]) -> Void)
    {
        guard let picker = xChooseAlbumPhotosViewController.init(maxImagesCount: maxImagesCount, delegate: nil) else {
            xWarning("图片选择器初始化失败")
            return
        }
        picker.didFinishPickingPhotosHandle = {
            (photos, assets, isSelectOriginalPhoto) in
            var ret1 = [UIImage]()
            photos?.forEach({
                (img) in
                ret1.append(img)
            })
            var ret2 = [PHAsset]()
            assets?.forEach({
                (obj) in
                if let ast = obj as? PHAsset {
                    ret2.append(ast)
                }
            })
            if ret1.count != ret2.count {
                xWarning("转换后的图片数和资源数不相等，请注意")
            }
            handler(ret1, ret2)
        }
        viewController.present(picker, animated: true, completion: nil)
    }
}
