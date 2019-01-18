//
//  ScrollBannerView.swift
//  ScrollBannerView
//
//  Created by liuyi on 2017/10/30.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit

public enum BannerViewPageControllAliment {
    case left
    case center
    case right
}

@objc public  protocol ScrollBannerViewDelegate: NSObjectProtocol {
    @objc optional func cycleScrollView(_ scrollView: ScrollBannerView, didSelectItemAtIndex index: Int)
    
    @objc optional  func cycleScrollView(_ scrollView: ScrollBannerView, didScorllToIndex index: Int)
}


//加 public 协议protocol的ScrollBannerView 才能获取
public class ScrollBannerView: UIView ,UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: - 外部调用属性
    public weak var delegate: ScrollBannerViewDelegate?
    //闭包
    public var clickItemClosure:((Int) ->Void)?
    //图片标题数组
    public var titleArr: [String] = []
    //图片路径数组
    public var imgPathArr: [String] = [] {
        didSet {
            setImgPaths()
        }
    }
    //默认图片
    public var placeholderImg = UIImage() {
        didSet {
            self.backgroundImgView.image = placeholderImg
        }
    }
    
    //MARK: - 滚动
    //是否无限滚动
    public var isInfiniteLoop = true
    
    let videoBtnImgV = UIImageView.init()
    public var showFirstVideoBtn = false {
        didSet {
            //videoBtnImgV.isHidden = showFirstVideoBtn
        }
    }

    //是否自动滚动，默认true
    public var isAutoScroll = true {
        didSet {
            setAutoScroll(isAutoScroll)
        }
    }
    //自动滚动时间间隔，默认2s
    public var autoScrollTimeIntervar: Float = 2 {
        didSet {
            setAutoScroll(isAutoScroll)
        }
    }
    //图片滚动方向，默认横向滚动
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = scrollDirection
        }
    }
    
    //MARK: - 分页控制 pageControl
    //位置，默认居中
    public var pageControlAliment:BannerViewPageControllAliment = .center
    //距离底部的间距
    public var pageControlBottomDis: CGFloat  = 10
    //距离左右间距，默认10
    public var pageControlSideDistance: CGFloat = 10
    //当前小圆点颜色
    public var currentPageDotColor = UIColor.white
    //其他页小圆点颜色
    public var pageDotColor = UIColor.gray
    //只有一张图是隐藏空间
    public var isHiddenWhenSinglePage = true
    
    //MARK: 标题文字
    //轮播文字label字体颜色
    public var titleLabelTextColor = UIColor.white
    //轮播文字字体大小
    public var titleLabelTextFont = UIFont.systemFont(ofSize: 15)
    //轮播label背景颜色，默认半透明
    public var titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    //轮播文字label的高度，默认35
    public var titleLabelHeight: CGFloat = 35
    //轮播文字label对齐方式，默认居左
    public var titleLabelTextAligment: NSTextAlignment = .left
    
    //MARK: - 私有属性
    fileprivate var timer: Timer?
    fileprivate var totalItemsCount = 0
    fileprivate var mainView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    var pageControl: UIPageControl?
    fileprivate lazy var backgroundImgView: UIImageView = {
        //当图片数组为空时的背景图
        let bgImgView = UIImageView()
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.layer.masksToBounds = true
        self.insertSubview(bgImgView, belowSubview: self.mainView)
        
        return bgImgView
    }()
    
    //MARK: -- 初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMainView()
    }
    //添加collectionView
    private func setupMainView() {
        self.backgroundColor = UIColor.lightGray
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.scrollDirection = .horizontal
        
        mainView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.register(BannerCell.self, forCellWithReuseIdentifier: NSStringFromClass(BannerCell.self))
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = self.bounds.size
        mainView.frame = self.bounds
        if (mainView.contentOffset.x == 0) && (totalItemsCount > 0) {
            var targetIndex = 0
            if isInfiniteLoop {
                targetIndex = totalItemsCount/2
            }
            mainView.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0) as IndexPath, at: UICollectionView.ScrollPosition.init(rawValue: 0), animated: false)
        }
        
        let pageDotSize = CGSize.init(width: 15, height: 10)
        let pageControlSize = CGSize.init(width: pageDotSize.width * CGFloat(imgPathArr.count), height: pageDotSize.height)
        let pageControlY = mainView.bounds.height - pageDotSize.height - pageControlBottomDis
        var pageConrolX:CGFloat = 0
        if pageControlAliment == .left {
            pageConrolX = pageControlSideDistance
        } else if pageControlAliment == .right {
            pageConrolX = mainView.bounds.width - pageControlSize.width - pageControlSideDistance
        } else if pageControlAliment == .center {
            pageConrolX = (mainView.bounds.width - pageControlSize.width) / 2.0
        }
        
        pageControl?.frame = CGRect.init(x: pageConrolX, y: pageControlY, width: pageControlSize.width, height: pageControlSize.height)
        self.backgroundImgView.frame = self.bounds
    }
    
    //释放
    public func releaseBannreView() {
        invalidateTimer()
    }
    
    deinit {
        print("deinit_________")
        mainView.delegate = nil
        mainView.dataSource = nil
    }
}

extension ScrollBannerView {
    //MARK: -- setProperty
    fileprivate func setAutoScroll(_ autoScroll: Bool) {
        invalidateTimer()
        if autoScroll {
            setupTimer()
        }
    }
    
    fileprivate func setImgPaths() {
        invalidateTimer()
        totalItemsCount = isInfiniteLoop ? imgPathArr.count * 100 : imgPathArr.count
        if imgPathArr.count > 1 {
            mainView.isScrollEnabled = true
            setAutoScroll(isAutoScroll)
        }else {
            mainView.isScrollEnabled = false
            setAutoScroll(false)
        }
        setupPageControl()
        mainView.reloadData()
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func setupTimer() {
        
        invalidateTimer()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollTimeIntervar), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func setupPageControl() {
        // 重新加载数据时调整
        pageControl?.removeFromSuperview()
        if imgPathArr.count == 0 {
            return
        }
        if (imgPathArr.count == 1) && isHiddenWhenSinglePage {
            return
        }
        
        let pageIndex = getPageControlIndex(getCurrentIndex())
        pageControl = UIPageControl()
        pageControl?.numberOfPages = imgPathArr.count
        pageControl?.currentPageIndicatorTintColor = currentPageDotColor
        pageControl?.pageIndicatorTintColor = pageDotColor
        pageControl?.isUserInteractionEnabled = false
        pageControl?.currentPage = pageIndex
        self.addSubview(pageControl!)
    }
}

extension ScrollBannerView {
    //MARK: -- collectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BannerCell.self), for: indexPath) as! BannerCell
        let cellIndex = getPageControlIndex(indexPath.item)
        //设置图片
        let imgPath = self.imgPathArr[cellIndex]
        if imgPath.hasPrefix("http") {
//            let imgStr:String = HDDeclare.IP_Request_Header() + imgPath
////            cell.backgroundColor = UIColor.red
            cell.imgView.kf.setImage(with: URL.init(string: imgPath), placeholder: UIImage.grayImage(sourceImageV: cell.imgView), options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            var img = UIImage.init(named: imgPath)
            if img == nil {
                img = UIImage.init(contentsOfFile: imgPath)
            }
            cell.imgView.image = img
        }
        //设置图片标题
        if cellIndex < titleArr.count {
            cell.title = titleArr[cellIndex]
        }else {
            cell.title = ""
        }
        if cell.isConfigured == false {
            cell.isConfigured = true
            cell.titleLabelTextColor = titleLabelTextColor
            cell.titleLabelTextFont = titleLabelTextFont
            cell.titleLabelBackgroundColor = titleLabelBackgroundColor
            cell.titleLabelTextAlignment = titleLabelTextAligment
            cell.titleLabelHeight = titleLabelHeight
        }
        cell.contentView.backgroundColor = UIColor.white
        cell.imgView.contentMode = UIView.ContentMode.scaleAspectFill
        
        let pageIndex = getPageControlIndex(getCurrentIndex())
        if pageIndex == 0 {
            videoBtnImgV.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
            videoBtnImgV.center = cell.contentView.center
            videoBtnImgV.image = UIImage.init(named: "A_video_playbtn")
            cell.contentView.addSubview(videoBtnImgV)
            videoBtnImgV.isHidden = !self.showFirstVideoBtn
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = getPageControlIndex(indexPath.item)
        delegate?.cycleScrollView!(self, didSelectItemAtIndex: index)
        clickItemClosure?(index)
        
    }
    
    //MARK: --- scrollView --
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imgPathArr.count == 0 {
            return
        }
        let cellIndex = getCurrentIndex()
        let indexOnPageControl = getPageControlIndex(cellIndex)
        pageControl?.currentPage = indexOnPageControl
        delegate?.cycleScrollView!(self, didScorllToIndex: indexOnPageControl)

    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if imgPathArr.count == 0 {
            return
        }
        let cellIndex = getCurrentIndex()
        let indexOnPageControl = getPageControlIndex(cellIndex)
        delegate?.cycleScrollView!(self, didScorllToIndex: indexOnPageControl)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll {
            invalidateTimer()
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll {
            setupTimer()
        }
    }
}


extension ScrollBannerView {
    //MARK: -- actions -
    // 定时器监听方法
    @objc fileprivate func automaticScroll() {
        
        if totalItemsCount == 0 {
            return
        }
        let curIndex = getCurrentIndex()
        let targetIndex = curIndex + 1
        scrollToIndex(targetIndex: targetIndex)
    }
    
    // 滚动至指定页面
    fileprivate func scrollToIndex(targetIndex: Int) {
        
        var targetIndex = targetIndex
        if targetIndex >= totalItemsCount {
            if isInfiniteLoop {
                targetIndex = totalItemsCount / 2
                mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: false)
            }
            return
        }
        mainView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: true)
    }
    
    // 获取当前cell下标
    fileprivate func getCurrentIndex() -> Int {
        
        if mainView.bounds.width == 0 || mainView.bounds.height == 0 {
            return 0
        }
        let index: Int
        if flowLayout.scrollDirection == .horizontal {
            index = Int((mainView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        } else {
            index = Int((mainView.contentOffset.y + flowLayout.itemSize.height * 0.5) / flowLayout.itemSize.height)
        }
        return index
    }
    
    // 获取当前页码下标
    fileprivate func getPageControlIndex(_ currentCellIndex: Int) -> Int {
        return currentCellIndex % imgPathArr.count
    }
    
}












