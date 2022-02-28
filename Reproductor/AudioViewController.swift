
import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    
    
    var player : AVAudioPlayer!
    var recorder : AVAudioRecorder!
    var file : URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        file = path[0].appendingPathComponent("sonido.m4a")

        initRecorder()
        initPlayer()
    }
    
    func initPlayer() {
        // let url = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        player = try? AVAudioPlayer(contentsOf: file)
        player.delegate = self
        
        print(player.duration)
        print(player.format)
        print(player.volume)
    }
    
    func initRecorder() {
        let settings = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 44100,
            AVNumberOfChannelsKey : 2,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
        ]
        recorder = try? AVAudioRecorder(url: file, settings: settings)
    }
    
    @IBAction func record(_ sender: Any) {
        if recorder.isRecording {
            recorder.stop()
        } else {
            recorder.record()
        }
    }
    
    @IBAction func play(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}
