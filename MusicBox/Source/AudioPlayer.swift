import AVFoundation
import Standard

extension String: Swift.Error {}

public class AudioPlaayer: NSObject {
  
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

    public func set(resource: AVAudioPlayer.Resource) throws {
        
        switch resource {
        case .data(let data):
            player = try AVAudioPlayer(data: data)
        case .url(let url):
            player = try AVAudioPlayer(contentsOf: url)
        case let .file(name, ext, bundle):
            if let url = bundle.url(forResource: name, withExtension: ext) {
                player = try AVAudioPlayer(contentsOf: url)
            } else {
                throw "Cannot load source name: \(name) with extension: \(ext ?? "") in bundle: \(bundle)"
            }
        }
        
        player?.delegate = self
    }
    
    public func togglePlay() {
        
        guard let player = player else { return }
        
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    public func play() {
        player?.play()
        isPlaying == true && (state = .playing)
    }
    
    public func pause() {
        player?.pause()
        isPaused && (state = .paused)
    }
    
    public func stop() {
        player?.stop()
        isStopped && (state = .stopped)
    }
    
    public var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    public var isStopped: Bool {
        return player != nil && duration == 0
    }
    
    public var isNone: Bool {
        return player == nil
    }
    
    public var isPaused: Bool {
        return player?.isPlaying == false && duration > 0
    }

    public var duration: TimeInterval {
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
    
    public enum Resource {
        case url(URL)
        case data(Data)
        case file(String, String?, Bundle)
    }
}

extension AudioPlaayer: AVAudioPlayerDelegate {
    
    private func audioPlayerDidFinishPlaying(_ pl: AVAudioPlayer, successfully flag: Bool) {
        state = .stopped
    }
    
    private func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        state = .none
    }
}
