//
//  HDLY_LocationTool.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import MapKit

protocol HDLY_LocationTool_Delegate: NSObjectProtocol {
    
    func didUpdateLocationInfo(city: String, coordinate: CLLocationCoordinate2D)
    
}

final class HDLY_LocationTool: NSObject,CLLocationManagerDelegate {

    static let shared = HDLY_LocationTool()
    let locManager: CLLocationManager  =  CLLocationManager()
    weak var delegate: HDLY_LocationTool_Delegate?
    var city: String?
    var coordinate: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        config()
    }
    
    //初始化设置
    func config() {
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;//定位精度百米以内
        locManager.distanceFilter = 200//水平或者垂直移动200米调用代理更新位置
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
    }
    
    func startLocation() {
        locManager.startUpdatingLocation()
    }
    
    func stopLocation() {
        locManager.stopUpdatingLocation()
    }
    
    //系统地图导航
    class func onNavForIOSMap(fromLoc:CLLocationCoordinate2D, endLoc: CLLocationCoordinate2D, endLocName: String) {
        let startItem: MKMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: fromLoc, addressDictionary: nil))
        startItem.name = "我的位置"
        
        let endItem: MKMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: endLoc, addressDictionary: nil))
        endItem.name = endLocName
        
        let mode:String = MKLaunchOptionsDirectionsModeDriving
        let options:Dictionary<String,Any> = [MKLaunchOptionsDirectionsModeKey : mode,
                                              MKLaunchOptionsMapTypeKey : NSNumber.init(value: MKMapType.standard.rawValue),
                                              MKLaunchOptionsShowsTrafficKey : NSNumber.init(value: true)]
        
        MKMapItem.openMaps(with: [startItem, endItem], launchOptions: options)
    }
    
    
    //百度地图导航
    class func onNavForBaiduMap(fromLoc:CLLocationCoordinate2D, endLoc: CLLocationCoordinate2D, endLocName: String) {
        
        var openUrlStr: String?
        
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            
            openUrlStr = "baidumap://map/direction?origin=latlng:\(fromLoc.latitude),\(fromLoc.longitude)|name:我的位置&destination=latlng:\(endLoc.latitude),\(endLoc.longitude)|name:\(endLocName)&mode=driving"
        }
        else {
            //相同城市
//        openUrlStr = "http://api.map.baidu.com/direction?origin=latlng:34.264642646862,108.95108518068|name:我家&destination=大雁塔&mode=driving&region=西安&output=html&src=webapp.baidu.openAPIdemo"
            
            //不同城市
            openUrlStr =  String.init(format: "http://api.map.baidu.com/direction?origin=latlng:%lf,%lf|name:当前位置&destination=latlng:%lf,%lf|name:%@&mode=driving&origin_region=天津&destination_region=北京&coord_type=wgs84&output=html&src=webapp.baidu.openAPIdemo", (fromLoc.latitude),(fromLoc.longitude), (endLoc.latitude),(endLoc.longitude),endLocName)
        }
        if openUrlStr != nil {
            let openUrl = URL.init(string: openUrlStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(openUrl!, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(openUrl!)
            }
        }
        
    }
    
}

//MARK: -- CLLocationManagerDelegate ---

extension HDLY_LocationTool {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("获得前后台授权")
        case .authorizedWhenInUse:
            print("获得前台授权")
            HDDeclare.shared.isSystemLocateEnable = true
        case .denied:
            if CLLocationManager.locationServicesEnabled() == true {
                print("定位服务开启，被拒绝")
            } else {
                print("定位服务关闭，不可用")
            }
            HDDeclare.shared.isSystemLocateEnable = false
        case .notDetermined:
            print("用户还未决定授权，检查plist是否添加Privacy - Location When In Use Usage Description 权限")
        case .restricted:
            print("访问受限")
            
        default:
            break
            
        }
    }
    
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last?.locationMarsFromEarth()
        if newLocation != nil {
            stopLocation()
            
            LOG("nowloc is latitude:\(String(describing: newLocation?.coordinate.latitude))  longitude:\(String(describing: newLocation?.coordinate.longitude))")
            coordinate = newLocation!.coordinate
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(newLocation!) { (placemarks, error) in
                let placeMark: CLPlacemark? = placemarks?.first
                if placeMark != nil {
                    LOG("name: \(String(describing: placeMark!.name))")//位置名
                    LOG("thoroughfare: \(String(describing: placeMark!.thoroughfare))")//街道
                    LOG("locality: \(String(describing: placeMark!.locality))")//市
                    LOG("subLocality: \(String(describing: placeMark!.subLocality))")//区
                    LOG("country: \(String(describing: placeMark!.country))")//国家

                    self.city = placeMark?.locality
                    
                    let cityName: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
                    if cityName == nil {
                        HDDeclare.shared.locModel.cityName = self.city ?? ""
                        HDDeclare.shared.locModel.latitude = "\(newLocation!.coordinate.latitude)"
                        HDDeclare.shared.locModel.longitude = "\(newLocation!.coordinate.longitude)"
                    }
                    
                    if self.delegate != nil {
                        self.delegate!.didUpdateLocationInfo(city: placeMark!.locality ?? "", coordinate: newLocation!.coordinate)
                    }
                }
            }
        }
    }
    
    
}


class HDLY_LocModel: NSObject {
    
    var cityName  : String = ""
    var longitude : String = ""
    var latitude  : String = ""
    
}


