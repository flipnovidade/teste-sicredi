
import UIKit
import RxSwift
import RxCocoa

class DetailVC: UIViewController {
    
    var detailViewModel = DetailViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ImageHeader: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var inputNome: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var btnPostTack: UIButton!
    
    var eventIdTrack: String = ""
    
    @IBAction func clickBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickPostTrack(_ sender: UIButton) {
        
        if( (self.inputNome.text == "" || self.inputNome.text == nil) || (self.inputEmail?.text  == "" || self.inputEmail.text == nil) ){
            
            MessageView.sharedInstance.showOnView(message: "Preencha o campo nome e email.", theme: .error)
            return
        }
   
        detailViewModel
        .trackPost
        .observeOn(MainScheduler.instance)
        .subscribe(     onNext: { _ in

                    },  onError: { erro in

                    },  onCompleted: {

                        self.inputNome.text = ""
                        self.inputEmail.text = ""
                        MessageView.sharedInstance.showOnView(message: "Cadastro feito com sucesso.", theme: .success)

                    },  onDisposed: {

                    })
        .disposed(by: disposeBag)
        
        let nameCustomer = self.inputNome.text ?? ""
        let emailCustomer = self.inputNome.text ?? ""
        detailViewModel.postDataTrack(eventId: eventIdTrack, name: nameCustomer, email: emailCustomer)

    }
    

    // MARK: - View's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBindings()
        detailViewModel.requestDataTrack(eventId: eventIdTrack)
    }
    
    private func setupBindings() {
        
        // binding loading to vc
        detailViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        detailViewModel
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
        detailViewModel
            .track
            .observeOn(MainScheduler.instance)
            .subscribe(     onNext: { track in
                
                                        self.labelTitle.text = track.name
                                        self.labelDescription.text = track.artist
                                        self.ImageHeader.loadImage(fromURL: track.trackArtWork)
                
                        },  onError: { erro in
                            
                        },  onCompleted: {
                            
                        },  onDisposed: {
                            
                        })
            .disposed(by: disposeBag)
    }


}


