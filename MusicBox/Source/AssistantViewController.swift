import MBUIKit
import AVFoundation

class AssistantViewController: UIViewController {
    
    deinit {
        resignNotifications()
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        registerNotifications()
        registerObservers()
    }
    
    private lazy var anim: CAAnimation = {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.repeatCount = .greatestFiniteMagnitude
        anim.duration = 10
        anim.timingFunction = .init(name: .linear)
        anim.toValue = CGFloat.pi * 2
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        return anim
    }()
    
    private var observations = [NSKeyValueObservation]()
}

// MARK: - IBActions
extension AssistantViewController {
    
    @IBAction private func tap(_ sender: UITapGestureRecognizer) {
        Assistent.audioPlayer.togglePlay()
    }
    
    @IBAction private func pan(_ sender: UIPanGestureRecognizer) {
        
        let view = UIApplication.shared.keyWindow?.rootViewController?.view
        let location = sender.location(in: view)
        
        switch sender.state {
        case .began: break
        case .changed:
            UIView.animate(withDuration: 0.08) {
                AssistiveControl.center = location
            }
        default:
            let frame = view!.safeAreaLayoutGuide.layoutFrame
            let controlW = AssistiveControl.bounds.width / 2 + 5
            //            let velocity = sender.velocity(in: view)
            
            UIView.animate(withDuration: 0.35) {
                AssistiveControl.center = CGPoint(
                    x: location.x > frame.width / 2 ? frame.maxX - controlW : frame.minX + controlW,
                    y: min(max(frame.minY + controlW, location.y), frame.maxY - controlW)
                )
            }
            
        }
    }
}

// MARK: - Animation
extension AssistantViewController {
    
    private func startAnimation() {
        
        guard Assistent.audioPlayer.isPlaying else { return }
        
        let pauseTime = view.layer.timeOffset
        
        view.layer.speed = 1
        view.layer.timeOffset = 0
        view.layer.beginTime = 0
        
        let continueTime = view.layer.convertTime(CACurrentMediaTime(), from: nil)
        view.layer.beginTime = continueTime - pauseTime
    }
    
    private func pauseAnimation() {
        
        let time = view.layer.convertTime(CACurrentMediaTime(), from: nil)
        view.layer.speed = 0
        view.layer.timeOffset = time
    }
    
    private func setupAnimation() {
        view.layer.add(anim, forKey: "com.dumbass.AssistiveViewController.transform.rotation.z")
        pauseAnimation()
    }
}

// MARK: - AssistantViewController.Notifications
extension AssistantViewController {
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AVAudioSession.routeChangeNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AVAudioSession.interruptionNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AudioPlayer.playerStateDidChangedNotification, object: nil)
    }
    
    private func resignNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
        
    @IBAction private func handleNotification(_ notification: NSNotification) {
        
        switch notification.name {
        case UIApplication.didEnterBackgroundNotification:
            pauseAnimation()
        case UIApplication.willEnterForegroundNotification:
            startAnimation()
        case AVAudioSession.routeChangeNotification:
            guard
                let userInfo = notification.userInfo,
                let reasonRawValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRawValue),
                reason == .oldDeviceUnavailable,
                let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription,
                previousRoute.outputs.first?.portType == .headphones else {
                    return
            }
            Assistent.audioPlayer.pause()
        case AVAudioSession.interruptionNotification:
            guard
                let typeRawValue = notification.userInfo?["AVAudioSessionInterruptionTypeKey"] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeRawValue) else {
                    return
            }
            
            switch type {
            case .began: Assistent.audioPlayer.pause()
            case .ended: Assistent.audioPlayer.play()
            @unknown default: fatalError()
            }
        case AudioPlayer.playerStateDidChangedNotification:
            guard let newValue = notification.userInfo?["newValue"] as? AudioPlayer.State else {
                return
            }
            newValue.isPlaying ? startAnimation() : pauseAnimation()
        default: break
        }
    }
}

// MARK: - AssistantViewController.Observers
extension AssistantViewController {
    
    func registerObservers() {
        observations = [
        ]
    }
    
    func removeObservers() {
        observations.removeAll()
    }
}

extension AssistantViewController: StoryboardRepresentable {
   
    static var sbName: String {
        return "Player"
    }
}
