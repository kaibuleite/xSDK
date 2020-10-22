//
//  xPreviewImagesViewController.swift
//  xSDK
//
//  Created by Mac on 2020/10/22.
//

import UIKit
import SDWebImage

public class xPreviewImagesViewController: xViewController {
    
    // MARK: - IBOutlet Property
    /// 滚动容器
    @IBOutlet weak var containerScroll: UIScrollView!
    
    // MARK: - Private Property
    /// 数据源
    var dataArray = [AnyObject]()
    /// 当前选中第几页
    var currentIndex = 0
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xPreviewImagesViewController.xNew(storyboard: "xPreviewImagesViewController")
        return vc as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.isRootParentViewController = true
        self.view.backgroundColor = .black
        self.topNaviBar?.barColor = UIColor.black.xEdit(alpha: 0.3)
        self.containerScroll.delegate = self
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    public override func addKit()
    {
        var frame = self.view.bounds
        for obj in self.dataArray
        {
            var icon : UIImageView?
            if let img = obj as? UIImage {
                icon = UIImageView.init(image: img)
            }
            else
            if let data = obj as? Data {
                let img = UIImage.init(data: data)
                icon = SDAnimatedImageView.init(image: img)
                
            }
            if let v = icon {
                v.contentMode = .scaleAspectFit
                v.frame = frame
                self.containerScroll.addSubview(v)
                frame.origin.x += frame.width
            }
        }
        self.containerScroll.contentSize = .init(width: frame.origin.x, height: 0)
        self.containerScroll.contentOffset = .init(x: CGFloat(self.currentIndex) * frame.width, y: 0)
        self.topNaviBar?.title = "\(self.currentIndex)/\(self.dataArray.count)"
    }
    
    // MARK: - Public Func
    /// 显示预览
    /// - Parameters:
    ///   - viewController: 上一级
    ///   - dataArray: 数据源
    ///   - index: 显示的图片编号
    ///   - animated: 是否动画
    public static func display(from viewController : UIViewController,
                               images : [UIImage],
                               index : Int,
                               animated : Bool = true)
    {
        let vc = xPreviewImagesViewController.quickInstancetype()
        vc.dataArray = images
        vc.currentIndex = index
        viewController.present(vc, animated: animated, completion: nil)
    }
    public static func display(from viewController : UIViewController,
                               gifs : [UIImage],
                               index : Int,
                               animated : Bool = true)
    {
        let vc = xPreviewImagesViewController.quickInstancetype()
        vc.dataArray = gifs
        vc.currentIndex = index
        viewController.present(vc, animated: animated, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate
extension xPreviewImagesViewController: UIScrollViewDelegate {
    
}
