import MBUIKit
import AVFoundation

class AssistantViewController: UIViewController {
    
    deinit {
        resignNotifications()
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPlayer()
        setupAnimation()
        registerNotifications()
        registerObservers()
    }
    
    private func initPlayer() {
        Assistent.audioPlayer.playerStateChanged = { [weak self] _, _, new in
            new.isPlaying ? self?.startAnimation() : self?.pauseAnimation()
        }
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
    
    private var notificationObjcs = [NSObjectProtocol]()
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

// MARK: - AssistantViewController.Notifications
extension AssistantViewController {
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AVAudioSession.routeChangeNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AVAudioSession.interruptionNotification, object: nil)

        
        notificationObjcs = [
            NotificationCenter.default.addObserver(
                forName: UIApplication.didEnterBackgroundNotification,
                object: nil, queue: nil,
                using: { [weak self] _ in
                    self?.pauseAnimation()
                }
            ),
            NotificationCenter.default.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil, queue: nil,
                using: { [weak self]_ in
                    self?.startAnimation()
                }
            ),
            NotificationCenter.default.addObserver(
                forName: AVAudioSession.routeChangeNotification,
                object: nil, queue: .main,
                using: { notification in
                    
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
                }
            ),
            NotificationCenter.default.addObserver(
                forName: AVAudioSession.interruptionNotification,
                object: nil, queue: nil,
                using: { notification in
                    
                    guard
                        let typeRawValue = notification.userInfo?["AVAudioSessionInterruptionTypeKey"] as? UInt,
                        let type = AVAudioSession.InterruptionType(rawValue: typeRawValue) else {
                            return
                    }
                    
                    switch type {
                    case .began: Assistent.audioPlayer.pause()
                    case .ended: Assistent.audioPlayer.play()
                    }
                }
            ),
        ]
    }
    
    @IBAction private func handleNotification(_ notification: NSNotification) {
        
    }
    
    private func resignNotifications() {
        notificationObjcs.forEach(NotificationCenter.default.removeObserver)
        notificationObjcs.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Animation
extension AssistantViewController {
    
    private func startAnimation() {
        guard Assistent.audioPlayer.state.isPlaying else { return }
        
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
