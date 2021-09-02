//
//  ResultViewController.swift
//  Expresso
//
//  Created by Jessi Febria on 03/05/21.
//

import UIKit
import AVFoundation

protocol ResultViewDelegate : AnyObject {
    func refreshRecordingView()
}


class ResultViewController: UIViewController {

    
    @IBOutlet weak var audioDuration: UILabel!
    @IBOutlet weak var clearResult: UILabel!
    @IBOutlet weak var fluentResult: UILabel!
    @IBOutlet weak var averageResult: UILabel!
    @IBOutlet weak var playAudioOutlet: UIButton!
    
    var resultViewDelegate : ResultViewDelegate?
    
    var audioPlayer = AVAudioPlayer()
    let audioURL = RecordingService.getAudioURL()
    var clearRate : Double = 0.0
    var fluentRate : Double = 0.0
    var duration : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is from result view controller")
        print(clearRate)
        
        clearResult.text = String(Double(round(clearRate*10)/10))
        fluentResult.text = String(Double(round(fluentRate*10)/10))
        enableAudioOutlet()
        
        averageResult.text = String(Double(round((clearRate+fluentRate)/2*10)/10))
        prepareAudio()
        
    }
    
    

    @IBAction func playAudio(_ sender: UIButton) {
        print("audio is playing")
        audioPlayer.play()
        audioPlayer.volume = 1
        
        playAudioOutlet.isEnabled = false
        playAudioOutlet.alpha = 0.5
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false){ [self] Timer in
            enableAudioOutlet()
        }
    }
    
    func prepareAudio() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            
            duration = Int(audioPlayer.duration)
            let hour = Int(duration/3600)
            let minute = Int(duration/60)
            let second = (duration%60)
            
            audioDuration.text = String(format: "%02d : %02d : %02d", hour, minute, second)
            
            
        } catch {
            print("audio failed")
        }
    }
    
    func enableAudioOutlet(){
        playAudioOutlet.isEnabled = true
        playAudioOutlet.alpha = 1
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        audioPlayer.stop()
        print("view will disappear")
        
        resultViewDelegate?.refreshRecordingView()
//        if let parentView = presentingViewController as? RecordingViewController {
//            print("view will disappear")
//            DispatchQueue.main.async {
//                parentView.setViewWhenRecording(status: false)
//            }
//        }
        
    }
    
}
