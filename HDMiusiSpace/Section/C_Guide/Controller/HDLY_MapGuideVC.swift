//
//  HDLY_MapGuideVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import CoreLocation

class HDLY_MapGuideVC: HDItemBaseVC {
    private var mapView : HDMapView?
    private var poiArray : Array<HDLY_MapList>?
    private var mapInfo: HDLY_MapData?
    
    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var errorBtn: UIButton!
    @IBOutlet weak var locBtn: UIButton!
    @IBOutlet weak var btnBig: UIButton!
    @IBOutlet weak var btnSmall: UIButton!
    @IBOutlet weak var scaleBgView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerBgView: UIView!
    @IBOutlet weak var playerBtn: UIButton!
    @IBOutlet weak var playerTitleL: UILabel!

    var player = HDLY_AudioPlayer.shared
    var museum_id = 0
    private var locationManager = CLLocationManager()
    private var nowLoc = CLLocationCoordinate2D()
    var chooseAnn: HDAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        self.title = "地图导览"
        getAllMapInformation()
        errorBtn.configShadow(cornerRadius: 22, shadowColor: UIColor.HexColor(0x000000, 0.3), shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.init(width: 0, height: 5))
        
        scaleBgView.configShadow(cornerRadius: 22, shadowColor: UIColor.HexColor(0x000000, 0.3), shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.init(width: 0, height: 5))
        
        //
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
        
        playerBgView.layer.cornerRadius = 22
        playerBgView.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showExhibitListNoti(noti:)), name: NSNotification.Name(rawValue: "kMapView_didTapHDCallOutView_Noti"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func showBigPoi(noti:Notification) {
        //self.avplayer.pauseAction()
    }

    @objc func showExhibitListNoti(noti: Notification) {
        let ann:HDAnnotation = noti.object as! HDAnnotation
        let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitListVC") as! HDLY_ExhibitListVC
        vc.exhibition_id = Int(ann.identify) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            player.stop()
        }
    }
    
}

extension HDLY_MapGuideVC:HDMapViewDelegate,HDMapViewDataSource {
    func mapViewInit() {
        guard let map = self.mapInfo else {
            return
        }
        DispatchQueue.main.async {
            self.mapviewClean()
            //地图尺寸
           
            let mapSize : CGSize = self.getMapSize()
            let mapV = HDMapView.init(frame: self.mapBgView.bounds, contentSize: mapSize)
            self.mapBgView.insertSubview(mapV!, at: 0)
            mapV?.minimumZoomScale = 1.5
            mapV?.zoomScale = 1.5
            mapV!.levelsOfZoom  = 4
            mapV!.levelsOfDetail = 3
            
            //
            let urlPrefix:String   = map.mapPath
            let mapItemCachePath:String = String.init(format: "%@/Resource/WebMap", kCachePath)
            mapV!.initMinMapImage(withUrlPrefix: urlPrefix, mapItemCachePath: mapItemCachePath)
            
            mapV!.dataSource = self
            mapV!.mapViewdelegate = self
            
            self.mapView = mapV
            self.showAllAnn(mapTemp: self.mapView!)
            
        }
    }
    //HD_NKM_MapViewDataSource
    func mapView(_ mapView: HDMapView!, imageForRow row: Int, column: Int, scale: Int) -> UIImage! {
        var scaleFolder : String = "125"
        if scale == 2 {
            scaleFolder = "250"
        }else if scale == 4 {
            scaleFolder = "500"
        }else if scale > 4 {
            scaleFolder = "1000"
        }
        let suffixPath = String.init(format: "1_%@_%ld_%ld.png", scaleFolder, column, row)
        let name = String.init(format: "%@/%@", mapView.mapItemCachePath,suffixPath)
        let myImage : UIImage? = UIImage.init(contentsOfFile: name)
        DispatchQueue.main.async {
            if myImage == nil && mapView == self.mapView{
                self.mapView?.recordItem(toSet: suffixPath)
            }
        }
        return myImage
    }
    
    //HD_NKM_MapViewDelegate
    func mapView(_ mapView: HDMapView!, tapAnnView annView: HDAnnotationView!) {
        self.mapView?.smallAllAnnView()
        
        if annView.annotation.annType == kAnnotationType_More {
            //self.showMapList(ann: annView.annotation)
        }
        else if annView.annotation.annType == kAnnotationType_One || annView.annotation.annType == kAnnotationType_ReadOne {
            annView.bigPicture()
            self.chooseAnn = annView.annotation
            self.playerTitleL.text = annView.annotation.title
        }
    }
    
    
    func mapviewClean() -> Void {
        if self.mapView != nil {
            self.mapView?.removeAllAnnatations(false)
            self.mapView?.removeFromSuperview()
            self.mapView?.mapViewdelegate = nil
            self.mapView?.dataSource = nil
            self.mapView = nil
        }
    }
}

//MARK: ---- POI ----
extension HDLY_MapGuideVC {
    
    private func showAllAnn(mapTemp : HDMapView) -> Void {
        if self.poiArray == nil {
            return
        }
        let userDef = UserDefaults.standard
        DispatchQueue.main.async {
            self.mapView?.removeAllAnnatations(false)
            
            self.poiArray!.forEach({ (model) in
                
                let poiLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(model.latitude), longitude: Double(model.longitude))
                let poiPoint: CGPoint = self.changeLocateToPoint(locate: poiLocation)
                
                let x = CGFloat(poiPoint.x) * mapTemp.zoomScale
                let y = CGFloat(poiPoint.y) * mapTemp.zoomScale
                
                let ann : HDAnnotation = HDAnnotation.annotation(with: CGPoint(x: x, y: y)) as! HDAnnotation
                ann.audio = model.audio
                ann.title = model.title
                ann.annType = kAnnotationType_One
                let key = "annIsRead_\(model.exhibitionID)"
                let isRead: Bool = userDef.bool(forKey: key)
                if isRead == true {
                    ann.annType = kAnnotationType_ReadOne
                }
                ann.star = String(model.star)
                ann.type = model.type
                ann.identify = String(model.exhibitionID)
                ann.size = CGSize.init(width: 35, height: 35)
                mapTemp.add(ann, animated: true)
            })
        }
    }
    
    
    private func getAllMapInformation() {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        //获取各楼层地图尺寸等信息
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getMapListAll(museum_id: 1, api_token: token), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            guard let model:HDLY_MapModel = try? jsonDecoder.decode(HDLY_MapModel.self, from: result) else {
                return
            }
            self.mapInfo = model.data
            self.poiArray = model.data.list
            self.mapViewInit()
        }) { (errorCode, msg) in
            
        }
    }
}

//MARK: --- actions ----

extension HDLY_MapGuideVC {
    
    @IBAction func playBtnAction(_ sender: Any) {
        guard let ann = self.chooseAnn else {
            return
        }
        if player.state == .playing {
            player.pause()
            playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControlState.normal)
        } else {
            if player.state == .paused {
                player.play()
            }else if ann.audio.contains(".mp3") {
                player.play(file: Music.init(name: "", url:URL.init(string: ann.audio)!))
                player.fileno = ann.identify
                ann.annType = kAnnotationType_ReadOne
                let key = "annIsRead_" + ann.identify
                UserDefaults.standard.set(true, forKey: key)
            }
            playerBtn.setImage(UIImage.init(named: "icon_pause_white"), for: UIControlState.normal)
        }
    }
    
    
    @IBAction func locBtnAction(_ sender: Any) {
        if (self.chooseAnn != nil) {
            self.mapView?.move(toCenter: chooseAnn?.identify)
        }
    }
    
    @IBAction func errorBtnAction(_ sender: Any) {
        //报错
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
        vc.articleID = String(museum_id)
        vc.typeID = "7"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mapBigAction(_ sender: Any) {
        self.mapView?.enlargeZoom()
    }
    
    @IBAction func mapSmallAction(_ sender: Any) {
        self.mapView?.narrowZoom()
    }
    
}


extension HDLY_MapGuideVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(NSTimeIntervalSince1970)
        let currlocation = locations.last
        nowLoc = (currlocation?.coordinate)!
        bigOutDoorPOI(locate: nowLoc)
//        distanceView.currLat.text = String.init(format: "2.当前纬度:%.6lf", nowLoc.latitude)
//        distanceView.currLon.text = String.init(format: "1.当前经度:%.6lf", nowLoc.longitude)
        
        
        //实时修改自己的位置
        if isInThisArea(point: nowLoc) {
 
        }
    }
    
    private func bigOutDoorPOI(locate: CLLocationCoordinate2D) {
        var center = CLLocationCoordinate2DMake(0, 0)
        if isInThisArea(point: self.nowLoc) {
            
        }
    }
    

    
    private func changeLocateToPoint(locate:CLLocationCoordinate2D) ->CGPoint {
        
        let latArr = self.getMapCoordinate()
        let Left_Start_Point = latArr[0]
        let Right_End_Point = latArr[1]
        
        let deltaPoint = CLLocationCoordinate2DMake(Right_End_Point.longitude - Left_Start_Point.longitude,Left_Start_Point.latitude - Right_End_Point.latitude) // (W,H)
        let mapSize = self.getMapSize() //瓦片地图大小

        // 纬度的差等于height，经度的差等于width
        let x = (locate.longitude - Left_Start_Point.longitude)
        let y = (Left_Start_Point.latitude - locate.latitude)
        
        let xpoint = x/deltaPoint.latitude * Double(mapSize.width)
        let ypoint = y/deltaPoint.longitude * Double(mapSize.height)
        
        return CGPoint(x:xpoint, y:ypoint)
    }
    
    private func getMapCoordinate() -> [CLLocationCoordinate2D] {
        guard let map = self.mapInfo else {
            return []
        }
        let coordinate:CLLocationCoordinate2D? = CLLocationCoordinate2D.init(latitude: map.leftTopLatitude, longitude: map.leftTopLongitude)
        let endCoordi:CLLocationCoordinate2D? = CLLocationCoordinate2D.init(latitude: map.rightBottomLatitude, longitude: map.rightBottomLongitude)
        return [coordinate!,endCoordi!]
    }
    
    private func getMapSize() -> CGSize {
        var size = CGSize.zero
        guard let map = self.mapInfo else {
            return size
        }
        size = CGSize(width: ceil(Double(map.width)/8), height: ceil(Double(map.height)/8))
        return size
    }
    
    
    private func isInThisArea(point:CLLocationCoordinate2D) -> Bool {
        let latArr = self.getMapCoordinate()
        let leftPoint = latArr[0]
        let rightPoint = latArr[1]
        
        var isInArea = false
        if (point.latitude < leftPoint.latitude && point.latitude > rightPoint.latitude
            && point.longitude > leftPoint.longitude && point.longitude < rightPoint.longitude) {
            isInArea = true
        }
        
        return isInArea
    }
    
//    private func  distanceFromPoi(center:CLLocationCoordinate2D,loc:CLLocationCoordinate2D,mapObj:MapExhibitModel) -> Bool {
//
//        if (center.latitude == 0 || center.longitude == 0){
//            return false
//        }
//        let dis = getTwoPointsDistance(point1: center, point2: loc)
////        self.coorLabel.text = "当前：lat:\(nowLoc.latitude),lon:\(nowLoc.longitude) \n实际距离：\(dis)米   触发距离：\(mapObj.range)米"
////
////        distanceView.distanceL.text = String.init(format: "6.距离:%.6lf", dis)
////        self.coorLabel.numberOfLines = 0
//        return dis < Double(mapObj.range)
//    }
    
    
    private func getTwoPointsDistance(point1:CLLocationCoordinate2D,point2:CLLocationCoordinate2D) ->(Double) {
        let er:Double = 6378137
        var radlat1 = .pi * point1.latitude/180.0
        var radlat2 = .pi * point2.latitude/180.0
        //now long.
        var radlong1 = .pi * point1.longitude/180.0
        var radlong2 = .pi * point2.longitude/180.0
        
        if( radlat1 < 0 ) {
            radlat1 = .pi/2 + fabs(radlat1);// south
        }
        if( radlat1 > 0 ) {
            radlat1 = .pi/2 - fabs(radlat1);// north
        }
        if( radlong1 < 0 ){
            radlong1 = .pi * 2 - fabs(radlong1);//west
        }
        if( radlat2 < 0 ){
            radlat2 = .pi/2 + fabs(radlat2);// south
        }
        if( radlat2 > 0 ) {
            radlat2 = .pi/2 - fabs(radlat2);// north
        }
        if( radlong2 < 0 ){
            radlong2 = .pi * 2 - fabs(radlong2);// west
        }
        //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
        //zero ag is up so reverse lat
        let x1 = er * cos(radlong1) * sin(radlat1)
        let y1 = er * sin(radlong1) * sin(radlat1)
        let z1 = er * cos(radlat1)
        let x2 = er * cos(radlong2) * sin(radlat2)
        let y2 = er * sin(radlong2) * sin(radlat2)
        let z2 = er * cos(radlat2)
        let d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2))
        //side, side, side, law of cosines and arccos
        let theta = acos((er*er+er*er-d*d)/(2*er*er))
        let dist  = theta*er;
        return dist
    }
}


