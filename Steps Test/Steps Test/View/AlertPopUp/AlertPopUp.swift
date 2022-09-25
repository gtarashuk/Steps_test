//
//  AlertPopUp.swift
//  oll.tv
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import UIKit

protocol AlertPopUpDelegate: AnyObject {
    func okButtonTapped()
}


class AlertPopUp: UIView, NibLoadable {
   
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: AlertPopUpDelegate?
 
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

 //MARK: - Initialization
    convenience init(title: String, message: String?) {
        self.init()
        titleLabel.text = title
        messageLabel.text = message
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib(withConstraintToSafeArea: true)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib(withConstraintToSafeArea: true)
        setupView()
    }
    
//MARK: - View setup
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview else {
            return
        }
        sv.subviews
            .filter { $0 is AlertPopUp }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 142).isActive = true
        self.widthAnchor.constraint(equalToConstant: 270).isActive = true
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        messageLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        separatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1011507203)
        backgroundView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2078431373, blue: 0.2156862745, alpha: 1)
        backgroundView.layer.cornerRadius = 14
        #if VODAFONE
        okButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        #else
        okButton.setTitleColor(#colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1), for: .normal)
        #endif
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    
    private func setConstrainsForDimmedView(view: UIView) {
        view.addSubview(dimmedView)
        dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setConstrainsForSelf(view: UIView) {
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        center = view.center
    }
    
    
    //MARK: - Displaying
    func display() {
        guard let view = UIApplication.shared.windows.last else {
            return
        }
        setConstrainsForDimmedView(view: view)
        setConstrainsForSelf(view: view)
    }
    
    @IBAction func mainButtonTapped(_ sender: Any) {
        delegate?.okButtonTapped()
        dimmedView.removeFromSuperview()
        self.removeFromSuperview()
    }
}
