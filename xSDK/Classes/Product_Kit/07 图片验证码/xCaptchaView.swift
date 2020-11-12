//
//  xCaptchaView.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

public class xCaptchaView: xView {
    
    // MARK: - Public Property
    /// 配置
    public var config = xCaptchaConfig()
    /// 是否不区分大小写
    public var isCaseInsensitive = true
    
    // MARK: - Private Property
    /// 验证码的字符串
    private var code = ""
    /// 字符素材数组
    private var charArray =
        ["0","1","2","3","4","5","6","7","8","9",
         "A","B","C","D","E","F","G","H","I","J",
         "K","L","M","N","O","P","Q","R","S","T",
         "U","V","W","X","Y","Z",
         "a","b","c","d","e","f","g","h","i","j",
         "k","l","m","n","o","p","q","r","s","t",
         "u","v","w","x","y","z"]
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundColor = UIColor.xNewRandom(alpha: 0.8)
        self.createNewCaptchaCode()
        self.setNeedsDisplay()
    }
    /// 点击界面，切换验证码
    public override func touchesBegan(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        //setNeedsDisplay调用drawRect方法来实现view的绘制
        self.createNewCaptchaCode()
        self.setNeedsDisplay()
    }
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        // 设置随机背景颜色
        self.backgroundColor = UIColor.xNewRandom(alpha: 0.8)
        // 获取单个字符的大小
        let font = UIFont.systemFont(ofSize: self.config.fontSize)
        let attr = [NSAttributedString.Key.font : font]
        let cSize = NSString(string: "A").size(withAttributes: attr)
        // 每个字符显示宽、高
        let count = self.code.count
        let width = rect.size.width / CGFloat(count)
        let height = rect.size.height
        // 多余的空间
        let overplusWidth = width - cSize.width
        let overplusHeight = height - cSize.height
        //依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
        var point = CGPoint.zero
        for i in 0 ..< count
        {
            // 如果有多余的空间,随机偏移值设为起始位置
            if overplusWidth > 0 {
                let margin = CGFloat(arc4random() % UInt32(overplusWidth))
                point.x = margin + width * CGFloat(i)
            }
            if overplusHeight > 0 {
                let margin = CGFloat(arc4random() % UInt32(overplusHeight))
                point.y = margin
            }
            let code = self.code as NSString
            let char = code.character(at: i)
            let nsChar = NSString(format: "%C", char)
            nsChar.draw(at: point,
                        withAttributes: attr)
        }
        // 绘制干扰的彩色直线
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.config.lineWidth)
        for _ in 0 ..< self.config.lineCount
        {
            // 设置线的随机颜色
            context?.setStrokeColor(UIColor.xNewRandom().cgColor)
            // 设置线的起点
            let x1 = CGFloat(arc4random() % UInt32(rect.size.width))
            let y1 = CGFloat(arc4random() % UInt32(rect.size.height))
            context?.move(to: .init(x: x1, y: y1))
            // 设置线终点
            let x2 = CGFloat(arc4random() % UInt32(rect.size.width))
            let y2 = CGFloat(arc4random() % UInt32(rect.size.height))
            context?.addLine(to: .init(x: x2, y: y2))
            // 画线
            context?.strokePath()
        }
    }

    // MARK: - Public Func
    /// 校验验证码
    public func check(code: String) -> Bool
    {
        if self.isCaseInsensitive {
            // 不区分大小写
            let ret = self.code.caseInsensitiveCompare(code)
            return ret == .orderedSame
        } else {
            // 区分大小写
            let ret = self.code.compare(code)
            return ret == .orderedSame
        }
    }

    // MARK: - Private Func
    /// 生成新的验证码字符串
    private func createNewCaptchaCode()
    {
        // 从字符数组中随机抽取相应数量的字符，组成验证码字符串
        self.code = ""
        // 随机从数组中选取需要个数的字符，然后拼接为一个字符串
        for _  in 0 ..< self.config.charCount
        {
            let idx = arc4random() % (UInt32(self.charArray.count - 1))
            let str = self.charArray[Int(idx)]
            self.code += str
        }
        print(self.code)
    }
}
