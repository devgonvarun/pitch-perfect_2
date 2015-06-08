//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Varun Devgon on 27/11/14.
//  Copyright (c) 2014 Varun Devgon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    //IBOutlets for UI Elements
    
    override func viewWillAppear(animated: Bool) {
        //viewWillAppear gets called every time the view appears.
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        //UI adjustments when recording starts
        stopButton.hidden = false
        tapToRecord.hidden = true
        recordingInProgress.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Date is passed as the name of the recorded file
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        //Function to create an audio recorder
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!,filePathUrl: recorder.url )
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording was not succesful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
           
            //This part of the code carries the recorded data to the PlaySoundsViewController
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        //For the stopping the active recording session
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
      
        super.didReceiveMemoryWarning()
        
    }
    

}

