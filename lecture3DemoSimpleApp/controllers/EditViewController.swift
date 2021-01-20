//
//  EditViewController.swift
//  lecture3DemoSimpleApp
//
//  Created by Tomiris Sayat on 20.01.2021.
//

import UIKit

class EditViewController: UIViewController {

   
    @IBOutlet weak var newTitle: UITextField!
    @IBOutlet weak var newDate: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var title1 = ""
    var date1 = ""
    var delegate: SecondViewControllerDelegate?
    var callBack:  ((_ title: String, _ deadline: String)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        newTitle.text = title1
        newDate.text = date1
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func edit(sender: UIButton) {
        let title = self.newTitle.text
        let date = self.newDate.text
        if date == "" || title == "" {return}
        callBack?( title!, date!)
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
