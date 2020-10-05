//
//  xChooseNavigationMapActionSheet.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit
import MapKit

public class xChooseNavigationMapActionSheet: NSObject {
    
    /*
        需要配置url白名单
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
     <array>
         <string>iosamap</string>
         <string>baidumap</string>
     </array>
     </plist>

     */
    
    // MARK: - Public Func
    /// 显示选择菜单
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - targetName: 目的地名称
    ///   - targetCoordinate: 目的地坐标
    public static func display(from viewController : UIViewController,
                               targetName : String,
                               targetCoordinate: CLLocationCoordinate2D)
    {
        let alert = UIAlertController.init(title: "选择", message: nil, preferredStyle: .actionSheet)
        // 高德地图 https://lbs.amap.com/api/amap-mobile/guide/ios/navi
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            let gaode = UIAlertAction.init(title: "高德地图", style: .default) {
                (sender) in
                self.openGaodeMap(with: targetName, coordinate: targetCoordinate)
            }
            alert.addAction(gaode)
        }
        // 百度地图 https://lbsyun.baidu.com/index.php?title=uri/api/ios
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            let baidu = UIAlertAction.init(title: "百度地图", style: .default) {
                (sender) in
                self.openBaiduMap(with: targetName, coordinate: targetCoordinate)
            }
            alert.addAction(baidu)
        }
        // 苹果自带地图
        let apple = UIAlertAction.init(title: "苹果地图", style: .default) {
            (sender) in
            self.openAppleMap(with: targetName, coordinate: targetCoordinate)
        }
        alert.addAction(apple)
        // 取消
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// 打开高德地图
    public static func openGaodeMap(with name : String,
                                    coordinate : CLLocationCoordinate2D)
    {
        // 拼接导航信息
        var urlStr = "iosamap://navi?"
        urlStr += "sourceApplication=福豆中康" + "&"
        urlStr += "poiname=\(name)" + "&"
        urlStr += "lat=\(coordinate.latitude)" + "&"
        urlStr += "lon=\(coordinate.longitude)" + "&"
        /*dev=0 这里填0就行了，跟上面的gcj02一个意思 1代表wgs84 也用不上*/
        urlStr += "dev=0" + "&"
        /*导航方式（0 速度快；1 费用少；2路程短...*/
        urlStr += "style=2"
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: chaset) else { return }
        guard let url = URL.init(string: str) else { return }
        UIApplication.shared.openURL(url)
    }
    
    /// 打开百度地图
    public static func openBaiduMap(with name : String,
                                    coordinate : CLLocationCoordinate2D)
    {
        // 拼接导航信息
        var urlStr = "baidumap://map/direction?"
        urlStr += "origin={{我的位置}}" + "&"
        urlStr += "destination=latlng:\(coordinate.latitude),\(coordinate.longitude)" + "|"
        urlStr += "name=\(name)" + "&"
        urlStr += "mode=driving" + "&" // 开车
        /*
         coord_type 允许的值为 bd09ll、gcj02、wgs84，
         如果你 APP 的地图 SDK 用的是百度地图 SDK，请填 bd09ll，否则就填gcj02*/
        urlStr += "coord_type=gcj02"
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: chaset) else { return }
        guard let url = URL.init(string: str) else { return }
        UIApplication.shared.openURL(url)
    }
    
    /// 打开苹果地图
    public static func openAppleMap(with name : String,
                                    coordinate : CLLocationCoordinate2D)
    {
        // 设置起点和终点
        let currentLoc = MKMapItem.forCurrentLocation()
        let toPlace = MKPlacemark.init(coordinate: coordinate, addressDictionary: nil)
        let toLoc = MKMapItem.init(placemark: toPlace)
        toLoc.name = name
        // 跳转地图
        /*
         *调用app自带导航，需要传入一个数组和一个字典，数组中放入MKMapItem，
         字典中放入对应键值

         MKLaunchOptionsDirectionsModeKey   开启导航模式
         MKLaunchOptionsDirectionsModeDriving   开车
         MKLaunchOptionsDirectionsModeWalking   步行
         
         MKLaunchOptionsMapTypeKey  地图模式
         MKMapTypeStandard = 0, 标准
         MKMapTypeSatellite,    卫星
         MKMapTypeHybrid        混合
         
         MKLaunchOptionsShowsTrafficKey 是否显示交通信息
         */
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                       MKLaunchOptionsMapTypeKey: 0,
                       MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        MKMapItem.openMaps(with: [currentLoc, toLoc],
                           launchOptions: options)
    }
    
}
