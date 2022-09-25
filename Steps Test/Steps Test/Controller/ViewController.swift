//
//  ViewController.swift
//  Steps Test
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, MBProgressHUDDelegate {
    @IBOutlet weak var lowerBoundTextField: UITextField!
    @IBOutlet weak var upperBoundTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var diff = 0
    var dataSource = [CommentElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lowerBoundTextField.becomeFirstResponder()
    }
    
    //MARK: -
    //Check all neccesary info before proceed to request
    
    func shouldProceed() -> Bool{
        guard let lowerBound = Int(self.lowerBoundTextField.text!) else {
            self.animateTextfield(textField: self.lowerBoundTextField)
            return false
        }
        guard let upperBound = Int(self.upperBoundTextField.text!) else {
            self.animateTextfield(textField: self.upperBoundTextField)
            return false
        }
        if upperBound - lowerBound > 0{
            self.diff = upperBound - lowerBound
            return true
        }else{
            self.animateTextfield(textField: self.lowerBoundTextField)
            self.animateTextfield(textField: self.upperBoundTextField)
            let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_bounds".localized())
            alertPopup.display()
            return false
        }
    }
    
    func animateTextfield(textField:UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))

        textField.layer.add(animation, forKey: "position")
    }
    
    func createProgressHUD(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading".localized()
        hud.button.setTitle("Cancel", for: .normal)
        hud.button.addTarget(self, action:#selector(cancelPreviousRequest) , for: .touchUpInside)
        hud.delegate = self
    }
    
    
    @IBAction func doSend(_ sender: Any) {
        if (self.shouldProceed()){
            self.dataSource.removeAll()
            //activity indicator with cancel button
            self.createProgressHUD()
            if diff > 10 {
                APIManager.shared().getComments(start: self.lowerBoundTextField.text ?? "0", limit: "10") { response in
                    self.dataSource = response
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "showResults", sender: self)
                } errorHandler: { error in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_default".localized())
                    alertPopup.display()
                }
            }else {
                APIManager.shared().getCommentsSlice(start: self.lowerBoundTextField.text ?? "0", end: self.upperBoundTextField.text ?? "0") { response in
                    self.dataSource = response
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "showResults", sender: self)
                } errorHandler: { error in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_default".localized())
                    alertPopup.display()
                }
            }
        }else {
            
        }
            
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showResults") {
            if let secondTVC = segue.destination as? SecondTableViewController{
                secondTVC.dataArray = self.dataSource
                secondTVC.upperBound = Int(self.upperBoundTextField.text!) ?? 0
                if diff < 10 {
                    secondTVC.needMore = false
                }
                
            }
        }
    }
    
    // MARK: - Action cancel
    
    @objc func cancelPreviousRequest() {
        MBProgressHUD.hide(for: self.view, animated: true)
        APIManager.shared().cancelPreviousRequest()
    }
    
}

