//
//  AlertPopUpManager.swift
//  Steps Test
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import UIKit

protocol AlertPopUpManagerDelegate: AnyObject {
    func alertPopManager(_ manager: AlertPopUpManager, didShow alert: AlertPopUp)
    func alertPopManager(_ manager: AlertPopUpManager, didTapOkButtonOn alert: AlertPopUp)
}

extension AlertPopUpManagerDelegate {
    func alertPopManager(_ manager: AlertPopUpManager, didShow alert: AlertPopUp) {}
}

class AlertPopUpManager {
    
    static let shared = AlertPopUpManager()
    
    weak var delegate: AlertPopUpManagerDelegate?

    private var isShowing: Bool = false
    private let alertPopUpView = AlertPopUp(title: "", message: "")
    
    private init() {
        alertPopUpView.delegate = self
    }
}

//MARK: - public
extension AlertPopUpManager {
    func show(title: String, message: String? = nil) {
        if isShowing { return }
        isShowing = true
        alertPopUpView.titleLabel.text = title
        alertPopUpView.messageLabel.text = message
        alertPopUpView.display()
        delegate?.alertPopManager(self, didShow: alertPopUpView)
    }
}

//MARK: - delegate alertPopUpView
extension AlertPopUpManager: AlertPopUpDelegate {
    func okButtonTapped() {
        delegate?.alertPopManager(self, didTapOkButtonOn: alertPopUpView)
        isShowing = false
    }
}

