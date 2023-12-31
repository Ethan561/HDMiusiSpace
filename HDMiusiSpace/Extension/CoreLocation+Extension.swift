//
//  CoreLocation+Extension.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import CoreLocation


// --- transform_earth_from_mars ---
// 参考来源：https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
let a:Double = 6378245.0
let ee:Double = 0.00669342162296594323

// --- transform_earth_from_mars end ---
// --- transform_mars_vs_bear_paw ---
// 参考来源：http://blog.woodbunny.com/post-68.html
let x_pi:Double = Double.pi * 3000.0 / 180.0


/*
 
 地球坐标(WGS84):
 国际标准  例如：CLLocationManager
 
 火星坐标 (GCJ-02):
 中国标准
 例如：iOS MKMapView、高德地图、国内google 、搜搜、阿里云
 
 百度坐标 (BD-09):
 
 百度标准
 例如：百度 SDK，地图
 
 */

public extension CLLocation {
    
    /// 从地球坐标转化到火星坐标
    ///
    /// - Returns: CLLocation
    func locationMarsFromEarth() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat + self.coordinate.latitude, longitude: n_lng + self.coordinate.longitude)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从火星坐标到地球坐标
    ///
    /// - Returns: CLLocation
    func locationEarthFromMars() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: self.coordinate.latitude - n_lat, longitude: self.coordinate.longitude - n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从火星坐标转化到百度坐标
    ///
    /// - Returns: CLLocation
    func locationBaiduFromMars() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_mars_from_baidu(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从百度坐标到火星坐标
    ///
    /// - Returns: CLLocation
    func locationMarsFromBaidu() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_baidu_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
        
    }
    
    /// 从百度坐标到地球坐标
    ///
    /// - Returns: CLLocation
    func locationEarthFromBaidu() -> CLLocation {
        
        let mars = self.locationMarsFromBaidu()
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: mars.coordinate.latitude, lng: mars.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: self.coordinate.latitude - n_lat, longitude: self.coordinate.longitude - n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    private class func transform_earth_from_mars(lat: Double, lng: Double) -> (Double, Double) {
        if CLLocation.transform_sino_out_china(lat: lat, lng: lng) {
            return (lat, lng)
        }
        var dLat = CLLocation.transform_earth_from_mars_lat(lng - 105.0, lat - 35.0)
        var dLng = CLLocation.transform_earth_from_mars_lng(lng - 105.0, lat - 35.0)
        let radLat = lat / 180.0 * Double.pi
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic:Double = sqrt(magic)
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Double.pi)
        dLng = (dLng * 180.0) / (a / sqrtMagic * cos(radLat) * Double.pi)
        return (dLat,dLng)
    }
    private class func transform_earth_from_mars_lat(_ x: Double,_ y: Double) -> Double {
        var ret: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0
        ret += (20.0 * sin(y * Double.pi) + 40.0 * sin(y / 3.0 * Double.pi)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * Double.pi) + 320 * sin(y * Double.pi / 30.0)) * 2.0 / 3.0
        return ret
    }
    private class func transform_earth_from_mars_lng(_ x: Double,_ y: Double) -> Double {
        var ret: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0
        ret += (20.0 * sin(x * Double.pi) + 40.0 * sin(x / 3.0 * Double.pi)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * Double.pi) + 300.0 * sin(x / 30.0 * Double.pi)) * 2.0 / 3.0
        return ret
    }
    private class func transform_mars_from_baidu(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng , y = lat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)
        return (z * sin(theta) + 0.006, z * cos(theta) + 0.0065)
    }
    private class func transform_baidu_from_mars(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng - 0.0065 , y = lat - 0.006
        let z =  sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        return (z * sin(theta), z * cos(theta))
    }
    private class func transform_sino_out_china(lat: Double, lng: Double) -> Bool {
        if (lng < 72.004 || lng > 137.8347) {
            return true
        }
        if (lat < 0.8293 || lat > 55.8271) {
            return true
        }
        return false
    }
}














