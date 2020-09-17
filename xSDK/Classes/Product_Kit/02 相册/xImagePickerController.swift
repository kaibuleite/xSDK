//
//  xImagePickerController.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Private Property
    /// 回调
    private var handler : xChoosePhotoAlert.xHandlerChoosePhoto?
    
    // MARK: - 内存释放
    deinit {
        self.handler = nil
        self.delegate = nil
        x_log("💥 照片库")
    }
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: - Public Func
    /// 开启相册(默认无法编辑图片)
    public func displayPhotoLibrary(from viewController : UIViewController,
                                    handler : @escaping xChoosePhotoAlert.xHandlerChoosePhoto)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            x_warning("相册数据源不可用")
            return
        }
        self.sourceType = .photoLibrary
        self.handler = handler
        viewController.present(self, animated: true, completion: nil)
    }
    
    /// 开启相机(默认无法编辑图片)
    public func displayCamera(from viewController : UIViewController,
                              handler : @escaping xChoosePhotoAlert.xHandlerChoosePhoto)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            x_warning("相机数据源不可用")
            return
        }
        self.sourceType = .camera
        self.handler = handler
        viewController.present(self, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    /// 获取图片
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let type : UIImagePickerController.InfoKey = picker.allowsEditing ? .editedImage : .originalImage
        guard let img = info[type] as? UIImage else {
            x_warning("获取图片失败")
            self.failure(picker)
            return
        }
        // 图片方向
        x_log("图片原始方向 = \(img.imageOrientation.rawValue)")
        picker.dismiss(animated: true) {
            self.handler?(img)
        }
    }
    /// 取消
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        x_log("用户取消选择")
        self.failure(picker)
    }
    /// 失败
    func failure(_ picker: UIImagePickerController) -> Void
    {
        x_log("图片获取失败")
        self.handler = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
