//
//  RootDViewModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class RootDViewModel: NSObject {
    //展览列表数组
    var exhibitionArray: Bindable = Bindable([HDSSL_dExhibition]())
    //博物馆列表数组
    var museumArray: Bindable = Bindable([HDSSL_dMuseum]())
    
    //请求展览列表
    func request_getExhibitionList(location: String,type: Int,vc: HDItemBaseVC) {
        print(location)
        
    }
    //请求博物馆列表
    func request_getMuseumList(location: String,type: Int,vc: HDItemBaseVC) {
        print(location)
        
    }
}
