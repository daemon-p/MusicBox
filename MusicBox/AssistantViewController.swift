import UIKit
import AVFoundation

let AssistiveControl: UIWindow = {
    let w: CGFloat = 48
    let window = UIWindow(frame: CGRect(x: 30, y: 200, width: w, height: w))
    window.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssistantViewController")
    window.makeKeyAndVisible()
    return window
}()

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
    
    @IBAction private func tap(_ sender: UITapGestureRecognizer) {
        audioPlayer.togglePlay()
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
            let velocity = sender.velocity(in: view)
            
            
            
            UIView.animate(withDuration: 0.35) {
                AssistiveControl.center = CGPoint(
                    x: location.x > frame.width / 2 ? frame.maxX - controlW : frame.minX + controlW,
                    y: min(max(frame.minY + controlW, location.y), frame.maxY - controlW)
                )
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    private func startAnimation() {
        guard audioPlayer.state.isPlaying else { return }
        
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
    
    private func initPlayer() {
         try? audioPlayer.set(resource: .file("Toca Toca.mp3", Bundle(for: AssistantViewController.self)))
        audioPlayer.playerStateChanged = { [weak self] _, _, new in
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
    
    let audioPlayer =  try! AudioPlaayer()
    private var notificationObjcs = [NSObjectProtocol]()
    private var observations = [NSKeyValueObservation]()

}

// MARK: - AssistantViewController.Notifications
extension AssistantViewController {
    
    private func registerNotifications() {
        
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
                using: { [weak self] notification in
                    
                    guard
                        let userInfo = notification.userInfo,
                        let reasonRawValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                        let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRawValue),
                        reason == .oldDeviceUnavailable,
                        let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription,
                        previousRoute.outputs.first?.portType == .headphones else {
                            return
                    }
                    self?.audioPlayer.pause()
                }
            ),
            NotificationCenter.default.addObserver(
                forName: AVAudioSession.interruptionNotification,
                object: nil, queue: nil,
                using: { [weak self] notification in
                    
                    guard
                        let typeRawValue = notification.userInfo?["AVAudioSessionInterruptionTypeKey"] as? UInt,
                        let type = AVAudioSession.InterruptionType(rawValue: typeRawValue) else {
                            return
                    }
                    
                    switch type {
                    case .began: self?.audioPlayer.pause()
                    case .ended: self?.audioPlayer.play()
                    }
                }
            ),
        ]
    }
    
    private func resignNotifications() {
        notificationObjcs.forEach(NotificationCenter.default.removeObserver)
        notificationObjcs.removeAll()
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
