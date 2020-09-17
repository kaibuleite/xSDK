//
//  xChoosePhotoAlert.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xChoosePhotoAlert: NSObject {

    // MARK: - Handler
    /// 选取照片回调
    public typealias xHandlerChoosePhoto = (UIImage) -> Void
    
    // MARK: - 内存释放
    deinit {
        x_log("💥 照片选择器")
    }
    
    // MARK: - 显示提示照片选择提示弹窗
    /// 开启照片选择提示栏
    ///
    /// handler必须实现,所以类型为 non-optional,此时需要使用 @escaping 逃逸
    /// - Parameters:
    ///   - parent: 父视图控制器
    ///   - allowsEditing: 是否允许系统编辑图片
    ///   - handler: 回调
    
    public static func display(from viewController : UIViewController,
                               albumTitle : String = "相册",
                               cameraTitle : String = "相机",
                               cancelTitle : String = "取消",
                               allowsEditing : Bool,
                               handler : @escaping xHandlerChoosePhoto) -> Void
    {
        let actionSheet = UIAlertController.init(title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        // 相册
        let album = UIAlertAction.init(title: albumTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController.init()
            picker.allowsEditing = allowsEditing
            picker.displayPhotoLibrary(from: viewController,
                                       handler: handler)
        }
        actionSheet.addAction(album)
        // 相机
        let camera = UIAlertAction.init(title: cameraTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController.init()
            picker.allowsEditing = allowsEditing
            picker.displayCamera(from: viewController,
                                 handler: handler)
        }
        actionSheet.addAction(camera)
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel, handler : nil)
        actionSheet.addAction(cancel)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

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
