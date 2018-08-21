//
//  RootBMainTableView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class RootBMainTableView: UITableView, UIGestureRecognizerDelegate {

    // 这个方法是支持多手势，当滑动子控制器中的scrollView时，MyTableView也能接收滑动事件
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }

}
