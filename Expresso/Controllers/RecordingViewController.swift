//
//  RecordingViewController.swift
//  Expresso
//
//  Created by Jessi Febria on 30/04/21.
//

import UIKit
import AVFoundation
import Speech

class RecordingViewController: UIViewController {

    var recordingSession: AVAudioSession?
    var audioFile: AVAudioFile?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var speechFinishedResult: SFSpeechRecognitionResult?
    
    let audioEngine = AVAudioEngine()
    var inputNode: AVAudioInputNode = AVAudioEngine().inputNode
    var audioplayer = AVAudioPlayerNode()
    let recognizer = SFSpeechRecognizer()
    let audioURL = RecordingService.getAudioURL()
    
    @IBOutlet weak var startRecordOutlet: UIButton!
    @IBOutlet weak var endRecordOutlet: UIButton!
   
    @IBOutlet weak var imagePerson: UIImageView!
    
    var person : Person?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        
        recognizer?.defaultTaskHint = .dictation
        
        if let person = person {
            self.navigationItem.title = person.name
            imagePerson.image = ImageService.getImage(id: Int(person.id))
            setViewWhenRecording(status: false)
        }
        
        imagePicker.delegate = self
        
        do {
            try recordingSession!.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession!.setActive(true)
            
            recordingSession!.requestRecordPermission { [ unowned self ] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("sukses")
                    } else {
                        print("gagal")
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        setViewWhenRecording(status: false)
    }
    
    @IBAction func rightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Action", message: "Choose your action", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Change Photo", style: .default, handler: { [self] action in
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete Person", style: .destructive, handler: { action in
            self.deletePerson()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel")
        }))
        
        
        self.present(actionSheet, animated: true) {
            "completed"
        }
        
    }
    
    func deletePerson(){
        let deleteAlert = UIAlertController(title: "Are you sure to delete this person?", message: "", preferredStyle: .alert)
                                            
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [self] UIAlertAction in
            
            PersonService().deletePerson(person: person!)
            
            performSegue(withIdentifier: "UnwindToHomepage", sender: self)
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func startRecord(_ sender: UIButton) {
        
        print(audioURL.absoluteString)
        
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        audioFile = try! AVAudioFile(forWriting: audioURL, settings: recordingFormat.settings, commonFormat: recordingFormat.commonFormat, interleaved: false)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.recognitionRequest?.append(buffer)
        
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("failed append buffer to audio file")
            }
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch  {
            print("failed to start audio engine")
        }
        
        startRecognition()
        
        setViewWhenRecording(status: true)
        
    } 

    
    func startRecognition(){
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        recognitionRequest?.taskHint = .dictation
        
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { [self] speechResult, error in
            
            recognizer?.defaultTaskHint = .dictation
            
            guard let speechResult = speechResult else {
                return
            }
            speechFinishedResult = speechResult
        })
        
    }
    var clearRate : Double = 0.0
    var smoothRate : Double = 0.0
    
    @IBAction func stopRecord(_ sender: UIButton) {
        
        self.recognitionTask?.finish()
        self.audioEngine.stop()
        
        inputNode.removeTap(onBus: 0)

        self.recognitionTask = nil
        self.recognitionRequest = nil
        
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [self] (timer) in
            (clearRate, smoothRate) = RecordingService().getClearAndSmoothRate(speechFinishedResult: self.speechFinishedResult)
            
            print("this is from controller")
            print(clearRate)
            print(smoothRate)
            
            performSegue(withIdentifier: "RecordingToResult", sender: sender)
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordingToResult" {
            let destinationVC = segue.destination as! ResultViewController
            print("preparing segue")
            print(clearRate)
            print(smoothRate)
            destinationVC.clearRate = clearRate
            destinationVC.fluentRate = smoothRate
            destinationVC.resultViewDelegate = self
        }
    }
    
   
    func setViewWhenRecording(status: Bool) {
        endRecordOutlet.isHidden = !status
        startRecordOutlet.isHidden = status
    }
    
    
    
}

extension RecordingViewController : ResultViewDelegate {
    func refreshRecordingView() {
        setViewWhenRecording(status: false)
    }
    
    
}



extension RecordingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        print("loading picture")

        if let imageChosen = info[.originalImage] as? UIImage {
            imagePerson.image = imageChosen
            ImageService.saveImage(id: Int(person!.id), image: imageChosen)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
