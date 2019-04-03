//
//  HDFloatingButtonManager.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/7/16.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

@objc protocol HDFloatingButtonManager_AudioPlayer_Delegate:NSObjectProtocol {
    @objc optional func finishPlaying()
    @objc optional func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float)
}


final class HDFloatingButtonManager: NSObject {
    static let manager = HDFloatingButtonManager.init()
    //需要显示悬浮按钮的界面
    var showFloatingBtnVCs:[String] = [String]()
    lazy var floatingBtnView = HDFloatingButtonView()
    
    //音频播放器
    var audioPlayer: STKAudioPlayer!
    //当前播放状态
    var state:STKAudioPlayerState = []
    //播放音频资源
    //var queue = [Music(name: "", url: URL(string: "")!)]
    var currentItem: Music?
    weak var delegate:HDFloatingButtonManager_AudioPlayer_Delegate?

    //当前播放音乐索引
    var currentIndex:Int = -1
    
    //是否循环播放
    var loop:Bool = false
    
    //更新进度条定时器
    var timer:Timer!
    var fileno: String = ""
    var url:String = ""
    var showFloatingBtn: Bool = false
    
    //
    var iconUrl: String? {
        didSet {
            showViewImg()
        }
    }
    
    var listenID: String?
    
    private override init() {
        super.init()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerIsPlayOrPause(noti:)), name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerFinishPlaying(noti:)), name: NSNotification.Name(rawValue: "AVPlayerFinishPlaying"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(avplayerInterruptionPauseNoti(noti:)), name: NSNotification.Name(rawValue: "AVPlayerInterruptionPauseNoti"), object: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(audioInterruptionNoti),name:NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeNoti(_:)),name:NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func setup() {
        configPlayer()
        //
        floatingBtnView.frame = CGRect.init(x: ScreenWidth - PlayWidth - 10, y: ScreenHeight * 0.3, width: PlayWidth, height: FolderHeight)
        floatingBtnView.delegate = self
        floatingBtnView.floatingButtonDidSelect = {
            self.pushToPlayerVC()
        }
        //
//        let path = Bundle.main.path(forResource: "gif", ofType: "gif")
//        let gifView: HDGIFImageView = HDGIFImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60), path: path!)
//         gifView.startAnimating()
//         floatingBtnView.addSubview(gifView)
//        gifView.isUserInteractionEnabled = false
    }
    
    func showViewImg() {
        guard let url = iconUrl else {
            return
        }
        if url.contains("http") {
            self.floatingBtnView.imgBtn.kf.setImage(with: URL.init(string: url), placeholder: UIImage.init(named: "img_kj_listen"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.floatingBtnView.imgBtn.image = UIImage.init(named: "img_kj_listen")
        }
    }
    
    func pushToPlayerVC()  {
        
        guard let id = listenID else {
            return
        }
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
        vc.listen_id = id
        
        //防止恶意点击
        UIApplication.shared.beginIgnoringInteractionEvents()
        let currentVC = self.topViewController()
        if currentVC?.navigationController != nil {
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.floatingBtnView.show = false
        
    }
    
    @objc func avplayerIsPlayOrPause(noti:Notification) {
    
        guard let topVC =  self.topViewController() else {
            return
        }
        if (topVC.isKind(of: HDLY_ListenDetail_VC.self)) {
            return
        }
        //LOG("vcname: \(topVC.className)")
        
        if let obj = noti.object as? Bool {
            if obj {
                floatingBtnView.showType = .FloatingButtonPlay
                floatingBtnView.playBtn.image = UIImage.init(named: "float_icon_pause")
                floatingBtnView.showView()
            } else {
                if HDLY_AudioPlayer.shared.state == .paused {
                    floatingBtnView.showType = .FloatingButtonPause
                    floatingBtnView.showView()
                }
            }
        }
        
        /*
        if self.showFloatingBtnVCs.contains(topVC.className) {
            if let obj = noti.object as? Bool {
                if obj {
                    floatingBtnView.show = true
                } else {
                    floatingBtnView.show = false
                }
            }
        }else {
            floatingBtnView.show = false
        }*/

    }
    
    @objc func avplayerFinishPlaying(noti:Notification) {
        floatingBtnView.closeAction()
    }
    
    @objc func avplayerInterruptionPauseNoti(noti:Notification) {
        pause()
        floatingBtnView.showType = .FloatingButtonPause
        if self.showFloatingBtn == true {
            floatingBtnView.showView()
        }
    }
    
}

extension HDFloatingButtonManager: HDFloatingButtonViewDelegate {
    
    func floatingButtonBeginMove(floatingView: HDFloatingButtonView, point: CGPoint) {
        
    }
    
    func floatingButtonMoved(floatingView: HDFloatingButtonView, point: CGPoint) {
        
    }
    
    func floatingButtonCancleMove(floatingView: HDFloatingButtonView) {
        
    }
    
}

//MARK: === player control =====
extension HDFloatingButtonManager:STKAudioPlayerDelegate {
    
    //初始化设置
    func configPlayer() {
        
        //重置播放器
        resetAudioPlayer()
        
        //设置一个定时器，每三秒钟滚动一次
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    //重置播放器
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
        audioPlayer.delegate = self
    }
    
    //开始播放歌曲列表（默认从第一首歌曲开始播放）
    func playWithQueue(queue: [Music], index: Int = 0) {
        guard index >= 0 && index < queue.count else {
            return
        }
        //        self.queue = queue
        audioPlayer.clearQueue()
        let url = queue[index].url
        audioPlayer.play(url)
        
        for i in 1 ..< queue.count {
            audioPlayer.queue(queue[Int((index + i) % queue.count)].url)
        }
        currentIndex = index
        loop = false
    }
    
    //停止播放
    func stop() {
        audioPlayer.stop()
        fileno = ""
        url = ""
        //        queue = []
        //        currentIndex = -1
    }
    
    //单独播放某个歌曲
    func play(file: Music) {
        audioPlayer.play(file.url)
        self.currentItem = file
    }
    
    func play() {
        audioPlayer.resume()
    }
    
    //暂停播放
    func pause() {
        audioPlayer.pause()
    }
    
    
    //定时器响应，更新进度条和时间
    @objc func tick() {
        if state == .playing {
            //更新进度条进度值
            //            self.playbackSlider!.value = Float(audioPlayer.progress)
            
            //一个小算法，来实现00：00这种格式的播放时间
            //            let all:Int=Int(audioPlayer.progress)
            
            let totalTime:Float64 = audioPlayer.duration
            let totalTimeStr:String = formatPlayTime(seconds: totalTime)
            
            let currentTime:Float64 = audioPlayer.progress
            let currentTimeStr:String = formatPlayTime(seconds: currentTime)
            //
            delegate?.playerTime!(currentTimeStr, totalTimeStr, Float(currentTime/totalTime))
            let isPlaying = true
            if showFloatingBtn == true {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: isPlaying)
            }
        }
    }
    
    //拖动进度条改变值时触发
    func audioPlayerSeekToTime(_ time: Float) {
        //播放器定位到对应的位置
        audioPlayer.seek(toTime: Double(time) * audioPlayer.duration)
        //如果当前时暂停状态，则继续播放
    }
    
    func formatPlayTime(seconds: Float64)->String{
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    
    //MARK: ==== STKAudioPlayerDelegate======
    
    //开始播放歌曲
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didStartPlayingQueueItemId queueItemId: NSObject) {
        //        if let index = (queue.index { $0.url == queueItemId as! URL }) {
        //            currentIndex = index
        //        }
    }
    
    //缓冲完毕
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        updateNowPlayingInfoCenter()
    }
    
    //播放状态变化
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     stateChanged state: STKAudioPlayerState,
                     previousState: STKAudioPlayerState) {
        self.state = state
        if state != .stopped && state != .error && state != .disposed {
        }
        updateNowPlayingInfoCenter()
        if state == .stopped {
            delegate?.finishPlaying!()
            if showFloatingBtn == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerFinishPlaying"), object: nil)
            }
        }
        
        if state == .playing || state == .paused  {
            var isPlaying = false
            if state == .playing {
                isPlaying = true
            }
            if showFloatingBtn == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: isPlaying)
            }
        }
    }
    
    //播放结束
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishPlayingQueueItemId queueItemId: NSObject,
                     with stopReason: STKAudioPlayerStopReason,
                     andProgress progress: Double, andDuration duration: Double) {
        
        //        if let index = (queue.index {
        //            $0.url == audioPlayer.currentlyPlayingQueueItemId() as! URL
        //        }) {
        //            currentIndex = index
        //        }
        //
        //        //自动播放下一曲
        LOG("stopReason:\(stopReason)")
        if stopReason == .eof {
            // next()
            delegate?.finishPlaying!()
            let isPlaying = false
            if showFloatingBtn == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: isPlaying)
            }
            
        } else if stopReason == .error {
            stop()
            resetAudioPlayer()
            let isPlaying = false
            if showFloatingBtn == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: isPlaying)
            }
        }
    }
    
    //发生错误
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print("Error when playing music \(errorCode)")
        resetAudioPlayer()
        //playWithQueue(queue: queue, index: currentIndex)
    }
    
    //更新当前播放信息
    func updateNowPlayingInfoCenter() {

    }
    
    //
    @objc func audioRouteChangeNoti(_ noti: Notification) {
        LOG("==== ----- audioRouteChangeNoti")
    }
    
    @objc func audioInterruptionNoti() {
        LOG("===== audioInterruptionNoti")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AVPlayerInterruptionPauseNoti"), object: nil)
        
    }
}


