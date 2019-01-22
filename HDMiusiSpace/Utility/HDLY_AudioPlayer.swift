//
//  HDLY_AudioPlayer.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/21.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

/*
 一个在线流媒体音乐播放器:
 使用第三方的 StreamingKit 库
 
 (1)StreamingKit 提供了一个简洁的面向对象 API，用于在 CoreAudio 框架下进行音频的解压和播放（采用硬件或软件编解码器）处理。
 （2）StreamingKit 的主要机制是对从播放器输入的数据源进行解耦，从而使高级定制的数据源可以进行诸如基于流媒体的渐进式下载、编码解码、自动恢复、动态缓冲之类的处理。StreamingKit 是唯一支持不同格式音频文件无缝播放的音频播放流媒体库。
 */

import UIKit

@objc protocol HDLY_AudioPlayer_Delegate:NSObjectProtocol {
    @objc optional func finishPlaying()
    @objc optional func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float)
}


final class HDLY_AudioPlayer: NSObject {
    
    static let shared = HDLY_AudioPlayer()
    
    //音频播放器
    var audioPlayer: STKAudioPlayer!
    
    //当前播放状态
    var state:STKAudioPlayerState = []
    //播放音频资源
//    var queue = [Music(name: "", url: URL(string: "")!)]
    var currentItem: Music?
    
    //当前播放音乐索引
    var currentIndex:Int = -1
    
    //是否循环播放
    var loop:Bool = false
    
    //更新进度条定时器
    var timer:Timer!
    var fileno: String = ""
    var url:String = ""
    var showFloatingBtn: Bool = false

    weak var delegate:HDLY_AudioPlayer_Delegate?
    
    private override init() {
        super.init()
       config()
    }
    
    //初始化设置
    func config() {
        
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
 
    
    //下一曲
    func next() {
//        guard queue.count > 0 else {
//            return
//        }
//        currentIndex = (currentIndex + 1) % queue.count
//        playWithQueue(queue: queue, index: currentIndex)
    }
    
    //上一曲
    func prev() {
        currentIndex = max(0, currentIndex - 1)
//        playWithQueue(queue: queue, index: currentIndex)
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
    
    
}


//Audio Player相关代理方法
extension HDLY_AudioPlayer: STKAudioPlayerDelegate {
    
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
//            next()
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
//        playWithQueue(queue: queue, index: currentIndex)
    }
    
    //更新当前播放信息
    func updateNowPlayingInfoCenter() {
//        if currentIndex >= 0 {
//            let music = queue[currentIndex]
//            //更新标题
//            titleLabel.text = "当前播放：\(music.name)"
//
//            //更新暂停按钮名字
//            let pauseBtnTitle = self.state == .playing ? "暂停" : "继续"
//            pauseBtn.setTitle(pauseBtnTitle, for: .normal)
//
//            //设置进度条相关属性
//            playbackSlider!.maximumValue = Float(audioPlayer.duration)
//        }else{
//            //停止播放
//            titleLabel.text = "播放停止!"
//            //更新进度条和时间标签
//            playbackSlider.value = 0
//            playTime.text = "--:--"
//        }
    }
    
    
}

//歌曲类
class Music {
    var name:String
    var url:URL
    
    //类构造函数
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}

