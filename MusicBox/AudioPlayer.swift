import AVFoundation

class AudioPlaayer: NSObject {
  
    init(resource: AVAudioPlayer.Resource? = nil) throws {
       
        super.init()
        try setup()
        try resource.flatMap(set)
    }
    
    deinit {
    }
    
    private func setup() throws {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
    }

    func set(resource: AVAudioPlayer.Resource) throws {
        
        switch resource {
        case .data(let data):
            player = try AVAudioPlayer(data: data)
        case .url(let url):
            player = try AVAudioPlayer(contentsOf: url)
        case let .file(name, bundle):
            if let url = bundle.url(forResource: name, withExtension: nil) {
                player = try AVAudioPlayer(contentsOf: url)
            } else {
                fatalError()
            }
        }
        
        player?.delegate = self
    }
    
    func togglePlay() {
        
        guard let player = player else { return }
        
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        player?.play()
        isPlaying == true && (state = .playing)
    }
    
    func pause() {
        player?.pause()
        isPaused && (state = .paused)
    }
    
    func stop() {
        player?.stop()
        isStopped && (state = .stopped)
    }
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    var isStopped: Bool {
        return player != nil && duration == 0
    }
    
    var isNone: Bool {
        return player == nil
    }
    
    var isPaused: Bool {
        return player?.isPlaying == false && duration > 0
    }

    var duration: TimeInterval {
        return player?.duration ?? 0
    }

    var playerStateChanged: ((AudioPlaayer, AVAudioPlayer.State, AVAudioPlayer.State) -> Void)?
    
    private(set) var state: AVAudioPlayer.State = .none {
        didSet {
            playerStateChanged?(self, oldValue, state)
        }
    }
    
    private var player: AVAudioPlayer? {
        didSet {
            isNone && (state = .none)
        }
    }
}

extension AVAudioPlayer {
    
    enum State {
        
        case playing
        case paused
        case stopped
        case none
        
        var isPlaying: Bool {
            return self == .playing
        }
        
        var isPaused: Bool {
            return self == .paused
        }
        
        var isStopped: Bool {
            return self == .stopped
        }
        
        var isNone: Bool {
            return self == .none
        }
    }
    
    enum Resource {
        case url(URL)
        case data(Data)
        case file(String, Bundle)
    }
}

extension AudioPlaayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ pl: AVAudioPlayer, successfully flag: Bool) {
        state = .stopped
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        state = .none
    }
}
