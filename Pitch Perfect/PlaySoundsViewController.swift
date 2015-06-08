//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Varun Devgon on 30/11/14.
//  Copyright (c) 2014 Varun Devgon. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    @IBOutlet weak var chipmunkButtonPresses: UIButton!
    @IBOutlet weak var darthvaderButtonPressed: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        //viewWillAppear gets called every time the view appears
        //UI adjustments for the Veiw
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
        audioPlayer.enableRate = true
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        stopAllAudio()
        //Stops all audio when the View dissapears
    }
    
    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        //A function to stop all audio
    }
    
    func playAudio(rate:float_t){
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        //A function to play audio at a particular rate passed as the argument
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        //Function for playing the recorded audio at variable pitch 
        //This function will be called in the pitch modulation audio effects which are chipmuk and darthvader
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
        //Function for snail effect
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
        //Function for rabbit effect
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        //Function for Chipmunk effect
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        //Function for Darth Vader effect
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    

}
