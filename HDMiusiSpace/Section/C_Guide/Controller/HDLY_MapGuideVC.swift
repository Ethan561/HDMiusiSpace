//
//  HDLY_MapGuideVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MapGuideVC: HDItemBaseVC {

    private var mapView : HDMapView?
    public  var currentFloor = "1"
//    private var poiArray : Array<MapExhibitData>?
    private var currRouteID:Int = 0
    private var isRouteShow:Bool = false
//    private var mapArray = [MapModel]()
    
    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var routeBtn: UIButton!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var locBtn: UIButton!
    @IBOutlet weak var floorChooseView: UIView!
    
    @IBOutlet weak var floorBtn: UIButton!
    @IBOutlet weak var btn1F: UIButton!
    @IBOutlet weak var btn2F: UIButton!
    @IBOutlet weak var btn3F: UIButton!
    var isShowServiceAnn  = false
    var isShowChooseView = false
    var player = HDLY_AudioPlayer.shared
    
    var mapImgPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地图导览"
//        getAllMapInformation()
//        setupNavBarItem()
//        floorChooseView.isHidden = true
//        setFloorChooseBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    func setupNavBarItem() {
//        let arBtn = UIButton.init(type: UIButton.ButtonType.custom)
//        arBtn.addTarget(self, action: #selector(arBtnAction(_:)), for: UIControl.Event.touchUpInside)
//        arBtn.setImage(UIImage.init(named: "A_AR_w"), for: UIControl.State.normal)
//        let arBtnItem = UIBarButtonItem.init(customView: arBtn)
//
//        let searchBtn = UIButton.init(type: UIButton.ButtonType.custom)
//        searchBtn.addTarget(self, action: #selector(searchBtnAction(_:)), for: UIControl.Event.touchUpInside)
//        searchBtn.setImage(UIImage.init(named: "A_search_w"), for: UIControl.State.normal)
//        let searchBtnItem = UIBarButtonItem.init(customView: searchBtn)
//
//        self.navigationItem.rightBarButtonItems = [searchBtnItem,arBtnItem]
//    }
    
 
//    }
    
    @objc func showBigPoi(noti:Notification) {
        //        self.avplayer.pauseAction()
    }

}

extension HDLY_MapGuideVC:HDMapViewDelegate,HDMapViewDataSource {
    func mapViewInit() {
        DispatchQueue.main.async {
            self.mapviewClean()
            let mapSize : CGSize = self.getMapSize(floorId: self.currentFloor) //地图尺寸
            let mapV = HDMapView.init(frame: self.mapBgView.bounds, contentSize: mapSize)
            self.mapBgView.insertSubview(mapV!, at: 0)
            mapV?.minimumZoomScale = 1.5
            mapV?.zoomScale = 1.5
            mapV!.levelsOfZoom  = 4
            mapV!.levelsOfDetail = 3
            
            //
            let mapPath:String = self.getMapPath(floorId: self.currentFloor)
            let urlPrefix:String   = HDDeclare.IP_Request_Header() + mapPath
            let mapItemCachePath:String = String.init(format: "%@/Resource/WebMap/%@", kCachePath, self.currentFloor)
            mapV!.initMinMapImage(withUrlPrefix: urlPrefix, mapItemCachePath: mapItemCachePath)
            
            mapV!.dataSource = self
            mapV!.mapViewdelegate = self
            
            self.mapView = mapV
            //请求点位信息
//            self.requestMapPoiInfo()
            
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
        let name = String.init(format: "%@/Resource/WebMap/%@/%@", kCachePath,self.currentFloor,suffixPath)
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
        else if annView.annotation.annType == kAnnotationType_One {
            //annView.bigPicture()
            
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
        /*
        if self.poiArray == nil {
            return
        }
        
        if (self.poiArray?.count)! > 0 {
            routeBtn.isSelected = false
            DispatchQueue.main.async {
                self.mapView?.removeAllAnnatations(false)
                
                self.poiArray?.forEach({ (modelD) in
                    
                    let mapData:MapExhibitData = modelD
                    
                    let x = CGFloat(mapData.x / 8) * mapTemp.zoomScale
                    let y = CGFloat(mapData.y / 8) * mapTemp.zoomScale
                    let ann : HDAnnotation = HDAnnotation.annotation(with: CGPoint(x: x, y: y)) as! HDAnnotation
                    if mapData.exhibit.count == 1 {
                        guard let model:MapExhibit = mapData.exhibit.first else {return}
                        ann.poiImgPath = HDDeclare.IP_Request_Header() + model.exhibitIcon1!
                        ann.audio = HDDeclare.IP_Request_Header() + model.audio
                        ann.title = model.exhibitName
                        ann.annType = kAnnotationType_One
                        ann.identify = String(model.exhibitID)
                        ann.size = CGSize.init(width: 70*0.7, height: 80*0.7)
                        
                    }else {
                        ann.annType = kAnnotationType_More
                        ann.pointCount = String(mapData.exhibitCount)
                        ann.identify = String(mapData.autonum)
                        ann.size = CGSize.init(width: 62*0.7, height: 78*0.7)
                        var titleName = ""
                        mapData.exhibit.forEach({ (m) in
                            if m.exhibitName != nil {
                                let name = m.exhibitName! + ","
                                titleName.append(name)
                            }
                        })
                        ann.title = titleName
                    }
                    mapTemp.add(ann, animated: true)
                })
            }
        }*/
        
    }
    
    /*
    private func showServiceAnn(pointArray: Array<MapServiceModel>, mapTemp: HDMapView) {
        if pointArray.count > 0 {
            DispatchQueue.main.async {
                self.mapView?.removeAllAnnatations(false)
                
                pointArray.forEach({ (model) in
                    let x = CGFloat(model.x / 8) * mapTemp.zoomScale
                    let y = CGFloat(model.y / 8) * mapTemp.zoomScale
                    let ann : HDAnnotation = HDAnnotation.annotation(with: CGPoint(x: x, y: y)) as! HDAnnotation
                    ann.annType = kAnnotationType_ServiceInfo
                    ann.poiImgPath = HDDeclare.IP_Request_Header() + model.img!
                    ann.size = CGSize.init(width: 40, height: 40)
                    mapTemp.add(ann, animated: true)
                })
            }
    }
     }*/
    
    func showMapRoadImg(path: String) {
        routeBtn.isSelected = true
        let url = HDDeclare.IP_Request_Header() + path
        self.mapView?.initRouteImage(url)
    }

    private func getMapSize(floorId:String) -> CGSize {
        let floor = Int(floorId)
        var size = CGSize.zero
//        if self.mapArray.count < 1 {
//            return size
//        }
//        self.mapArray.forEach { (map) in
//            if map.map_id == floor {
//                size = CGSize(width: ceil(Double(map.width)/8), height: ceil(Double(map.height)/8))
//            }
//        }
        return size
    }
    private func getMapPath(floorId:String) -> String {
        let floor = Int(floorId)
        var path = ""
//        if self.mapArray.count < 1 {
//            return ""
//        }
//        self.mapArray.forEach { (map) in
//            if map.map_id == floor {
//                path = map.map_path ?? ""
//            }
//        }
        return path
    }
        /*
    
    
    private func getAllMapInformation() {
        //获取各楼层地图尺寸等信息
        HD_LY_NetHelper.loadData(API: HDLY_API.self, target: .getMapListAll(floorNum: 0, language: "1"), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            guard let model:HDMapDataModel = try? jsonDecoder.decode(HDMapDataModel.self, from: result) else {
                return
            }
            self.mapArray = model.data
            self.mapViewInit()
        }) { (errorCode, msg) in
            
        }
    }
    
    //获取地图点位信息
    private func requestMapPoiInfo() -> Void {
        var apiToken = HDDeclare.shared.api_token
        if apiToken == nil  {
            apiToken = ""
        }
        HD_LY_NetHelper.loadData(API: HDLY_API.self, target: .getMapExhibitListA(map_id: self.currentFloor, language: "1"), success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            guard let model:HDLY_MapExhibitModel = try? jsonDecoder.decode(HDLY_MapExhibitModel.self, from: result) else {
                return
            }
            let exhibits = model.data
            if exhibits.count > 0 {
                self.poiArray = exhibits
                self.showAllAnn(mapTemp: self.mapView!)
            }
        }) { (errorCode, msg) in
            LOG("errorCode: \(String(describing: errorCode)),msg:\(msg)")
        }
    }
    
    
    private func requestMapServiceInfo() -> Void {
        HD_LY_NetHelper.loadData(API: HDLY_API.self, target: .getMapServicePoint(map_id: self.currentFloor), success: { (result) in
            let jsonDecoder = JSONDecoder()
            guard let model:Services = try? jsonDecoder.decode(Services.self, from: result) else {
                return
            }
            if let services = model.data {
                self.showServiceAnn(pointArray: services, mapTemp: self.mapView!)
            }
        }) { (errorCode, msg) in
            LOG("errorCode: \(String(describing: errorCode)),msg:\(msg)")
        }
    }*/
    
    
}

