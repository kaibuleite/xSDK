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
    var dataArray = [Any]()
    /// 图片控件
    var iconArray = [SDAnimatedImageView]()
    /// 当前选中第几页
    var currentIndex = 0
    
    // MARK: - 内存释放
    deinit {
        for icon in self.iconArray {
            icon.stopAnimating()
        }
        self.containerScroll.delegate = nil
    }
    
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
        for (i, obj) in self.dataArray.enumerated()
        {
            let icon = SDAnimatedImageView.init()
            icon.tag = i
            icon.contentMode = .scaleAspectFit
            icon.clearBufferWhenStopped = true  // 暂停时移除缓存（降低内存消耗）
            if let img = obj as? UIImage {
                icon.image = img
            }
            else
            if let data = obj as? Data {
                let img = SDAnimatedImage.init(data: data)
                icon.image = img
            }
            else
            if let str = obj as? String {
                let url = URL.init(string: str)
                icon.sd_setImage(with: url) {
                    [weak self] (img, err, CacheType, url) in
                    guard let ws = self else { return }
                    if icon.tag == ws.currentIndex {
                        icon.startAnimating()
                    }
                }
            }
            else {
                xWarning("要预览的图片数据格式不对:\(obj)")
            }
            icon.frame = frame
            self.containerScroll.addSubview(icon)
            self.iconArray.append(icon)
            icon.stopAnimating()    // 先不执行动画
            frame.origin.x += frame.width
        }
        self.containerScroll.contentSize = .init(width: frame.origin.x, height: 0)
        let ofx = CGFloat(self.currentIndex) * frame.width
        self.containerScroll.contentOffset = .init(x: ofx, y: 0)
        self.scrollEnd()
    }
    
    // MARK: - Public Func
    /// 显示预览
    /// - Parameters:
    ///   - viewController: 上一级
    ///   - images: 图片
    ///   - index: 显示的图片编号
    ///   - animated: 是否动画
    public static func display(from viewController : UIViewController,
                               images : [UIImage],
                               index : Int = 0,
                               animated : Bool = true)
    {
        let vc = xPreviewImagesViewController.quickInstancetype()
        vc.dataArray = images
        vc.currentIndex = index
        viewController.present(vc, animated: animated, completion: nil)
    }
    /// 显示预览
    /// - Parameters:
    ///   - viewController: 上一级
    ///   - datas: 图片数据（支持gif）
    ///   - index: 显示的图片编号
    ///   - animated: 是否动画
    public static func display(from viewController : UIViewController,
                               datas : [Data],
                               index : Int = 0,
                               animated : Bool = true)
    {
        let vc = xPreviewImagesViewController.quickInstancetype()
        vc.dataArray = datas
        vc.currentIndex = index
        viewController.present(vc, animated: animated, completion: nil)
    }
    /// 显示预览
    /// - Parameters:
    ///   - viewController: 上一级
    ///   - imageUrls: 图片链接
    ///   - index: 显示的图片编号
    ///   - animated: 是否动画
    public static func display(from viewController : UIViewController,
                               imageUrls : [String],
                               index : Int = 0,
                               animated : Bool = true)
    {
        let vc = xPreviewImagesViewController.quickInstancetype()
        vc.dataArray = imageUrls
        vc.currentIndex = index
        viewController.present(vc, animated: animated, completion: nil)
    }
     
    // MARK: - Private Func
    /// 滚动结束
    private func scrollEnd()
    {
        let x = self.containerScroll.contentOffset.x
        let w = self.containerScroll.bounds.width
        let page = (x + 10) / w
        self.currentIndex = Int(page)
        self.topNaviBar?.title = "\(self.currentIndex + 1)/\(self.dataArray.count)"
        for icon in self.iconArray {
            if icon.tag == self.currentIndex {
                icon.startAnimating()
            } else {
                icon.stopAnimating()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension xPreviewImagesViewController: UIScrollViewDelegate {
     
    /* 滚动完毕就会调用（人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollEnd()
    }
    /* 滚动完毕就会调用（不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）*/
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollEnd()
    }
    
}
