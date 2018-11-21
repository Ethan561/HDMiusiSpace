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
    
}

//MARK: -- CLLocationManagerDelegate ---

extension HDLY_LocationTool {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
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
                    if self.delegate != nil {
                        self.delegate!.didUpdateLocationInfo(city: placeMark!.locality ?? "", coordinate: newLocation!.coordinate)
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined://用户还未决定授权
            manager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }

}
