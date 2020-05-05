
import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    var homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - SubViews
    @IBOutlet weak var tracksVCView: UIView!
    
    private lazy var tracksViewController: TracksTableViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TracksTableViewVC") as! TracksTableViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: tracksVCView)
        
        return viewController
    }()
    
    // MARK: - View's Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBindings()
        homeViewModel.requestData()
    }
    
    
    // MARK: - Bindings
    private func setupBindings() {
        
        // binding loading to vc
        homeViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
        
        // binding tracks to track container
        homeViewModel
            .tracks
            .observeOn(MainScheduler.instance)
            .bind(to: tracksViewController.tracks)
            .disposed(by: disposeBag)
       
    }
    
}
