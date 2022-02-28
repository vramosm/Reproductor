//
//  PlayerViewController.swift
//  Reproductor
//
//  Created by user192546 on 2/26/22.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {

    var position: Int = 0
    var songs: [Song] = []

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    
    var player = AVAudioPlayer()
    var timer: Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        timeSlider.maximumValue = Float(player.duration)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.displayCurrentTime), userInfo: nil, repeats: true)

       
    }


    func configure() {
        let song = songs[position]
        //chooseRandomSong()
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.trackName, ofType: "mp3")!)
        albumImageView.image = UIImage(named: song.imageName)
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        player = try! AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
        randomButton.tintColor = .black
    }
    

    func chooseRandomSong(){
        
        position = Int.random(in:0...3)
        configure()
        player.play()
    }
    @objc func displayCurrentTime() {
        timeSlider.value = Float(player.currentTime)
        DispatchQueue.main.async {
            // this is to compute and show remaining time
            let durat = Int((self.player.duration - (self.player.currentTime)))
            let minutes2 = durat/60
            let seconds2 = durat - minutes2 * 60
            self.durationLabel.text = NSString(format: "%02d:%02d", minutes2,seconds2) as String

                //This is to show and compute current time
            let currentT = Int((self.player.currentTime))
            let minutes = currentT/60
            let seconds = currentT - minutes * 60
            self.timerLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        if position > 0 {
            position = position - 1
            /*player.stop()
            player.prepareToPlay()
            timer?.invalidate()
            timer = nil
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)*/
            configure()
            player.play()
            
            
        }
    }
    @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func didTapNextButton(_ sender: UIButton) {
        
       
        if position < (songs.count - 1) {
            position = position + 1
            player.stop()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            /*timer?.invalidate()
            timer = nil
            */
            configure()
            player.play()
        }
    }
    
    @IBAction func seek(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(timeSlider.value)
        player.prepareToPlay()
        player.play()
        timeSlider.maximumValue = Float(player.duration)
        
        }
    
    /*func updateSlider() {
        let value = Float(player.currentTime / player.duration)
        timeSlider.value = value
    }*/
 
    @IBAction func randomSong(_ sender: Any) {
        chooseRandomSong()
    }
}
