//
//  HDLY_AnswerAudio_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/25.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import AVFoundation

protocol AnswerAudioDelegate: NSObjectProtocol {
//    func voiceBubbleDidStartPlaying(_ cell: HDLY_AnswerAudio_Cell)
    func voiceBubbleStratOrStop(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo)
}

class HDLY_AnswerAudio_Cell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var audioTimeL: UILabel!
    @IBOutlet weak var audioPlayBtn: UIButton!
    @IBOutlet weak var waveBtn: UIButton!
    //
    var player: AVAudioPlayer!
    var asset: AVURLAsset!
    var animationImages = [Any]()
    private var myTimer: Timer?
    weak var delegate: AnswerAudioDelegate?
    var model: QuestionReturnInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImgV.layer.cornerRadius = 15
        bgView.layer.cornerRadius = 4
        moreBtn.isHidden = true
    }

    @IBAction func playAction(_ sender: UIButton) {
        guard let res = self.model else {
            return
        }
        delegate?.voiceBubbleStratOrStop(self, res)
//        if self.waveBtn.imageView!.isAnimating {
//            stop()
//        }else {
//            play()
////            delegate?.voiceBubbleDidStartPlaying(self)
//        }
        
    }
    
    // MARK: - Public
    func startAnimating(){
//        let session:AVAudioSession = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSessionCategoryPlayback)
//
//        delegate?.voiceBubbleStratOrStop(self,true)

        justStartAnimating()
    }
    // MARK: - 开始动画
    func justStartAnimating(){
        let image0: UIImage! = UIImage.init(named: "fs_icon_wave_0")
        let image1: UIImage! = UIImage.init(named: "fs_icon_wave_1")
        let image2: UIImage! = UIImage.init(named: "fs_icon_wave_2")
        let animationImages: [UIImage] = [image0, image1, image2]
        if !(self.waveBtn.imageView?.isAnimating)! {
            self.waveBtn.imageView?.animationImages = animationImages
            self.waveBtn.imageView?.animationDuration = 3.0 * 0.7
            self.waveBtn.imageView?.startAnimating()
        }
    }
    // MARK: - 停止动画
    func stopAnimating(){
//        delegate?.voiceBubbleStratOrStop(self,false)
        if (waveBtn.imageView?.isAnimating)! {
            waveBtn.imageView?.stopAnimating()
        }
    }
    
    
    func play() {
//        if !(self.contentURL != nil) {
//            print("没有设置URL")
//            return
//        }
        
//        if !player.isPlaying{
//            player.play()
//        }
        startAnimating()
    }
    
    func pause() {
        if player != nil &&  player.isPlaying {
            player.pause()
            stopAnimating()
        }
    }
    
    func stop() {
//        if player != nil && player.isPlaying {
//            player.stop()
//            player.currentTime = 0
//        }
        stopAnimating()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_AnswerAudio_Cell! {
        var cell: HDLY_AnswerAudio_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_AnswerAudio_Cell.className) as? HDLY_AnswerAudio_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_AnswerAudio_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_AnswerAudio_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_AnswerAudio_Cell.className, owner: nil, options: nil)?.first as? HDLY_AnswerAudio_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
}



