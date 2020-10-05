//
//  xChoosePhotoActionSheet.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xChoosePhotoActionSheet: NSObject {

    // MARK: - Handler
    /// 选取照片回调
    public typealias xHandlerChoosePhoto = (UIImage) -> Void
    
    // MARK: - 内存释放
    deinit {
        xLog("💥 照片选择器")
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
                               choose handler : @escaping xHandlerChoosePhoto) -> Void
    {
        let actionSheet = UIAlertController.init(title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        // 相册
        let album = UIAlertAction.init(title: albumTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController.init()
            picker.allowsEditing = allowsEditing
            picker.displayAlbum(from: viewController, choose: handler)
        }
        actionSheet.addAction(album)
        // 相机
        let camera = UIAlertAction.init(title: cameraTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController.init()
            picker.allowsEditing = allowsEditing
            picker.displayCamera(from: viewController, choose: handler)
        }
        actionSheet.addAction(camera)
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel, handler : nil)
        actionSheet.addAction(cancel)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
