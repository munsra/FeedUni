//
//  ProfileController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 28/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!

    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        print("Logout pressed")
        UserDefaults.standard.setValue(false, forKey: "ricordami")
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}