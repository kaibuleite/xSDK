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
    private var chooseHandler : xChoosePhotoActionSheet.xHandlerChoosePhoto?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.delegate = nil
        xLog("💥 照片库")
    }
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: - Public Func
    /// 开启相册(默认无法编辑图片)
    public func displayAlbum(from viewController : UIViewController,
                             choose handler : @escaping xChoosePhotoActionSheet.xHandlerChoosePhoto)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            xWarning("相册数据源不可用")
            return
        }
        self.sourceType = .photoLibrary
        self.chooseHandler = handler
        viewController.present(self, animated: true, completion: nil)
    }
    
    /// 开启相机(默认无法编辑图片)
    public func displayCamera(from viewController : UIViewController,
                              choose handler : @escaping xChoosePhotoActionSheet.xHandlerChoosePhoto)
    {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            xWarning("相机数据源不可用")
            return
        }
        self.sourceType = .camera
        self.chooseHandler = handler
        viewController.present(self, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    /// 获取图片
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let type : UIImagePickerController.InfoKey = picker.allowsEditing ? .editedImage : .originalImage
        guard let img = info[type] as? UIImage else {
            xWarning("获取图片失败")
            self.failure(picker)
            return
        }
        // 图片方向
        xLog("图片原始方向 = \(img.imageOrientation.rawValue)")
        picker.dismiss(animated: true) {
            self.chooseHandler?(img)
        }
    }
    /// 取消
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        xLog("用户取消选择")
        self.failure(picker)
    }
    /// 失败
    func failure(_ picker: UIImagePickerController) -> Void
    {
        xLog("图片获取失败")
        picker.dismiss(animated: true, completion: nil)
    }
}
