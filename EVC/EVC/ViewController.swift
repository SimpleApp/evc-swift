//
//  ViewController.swift
//  EVC
//
//  Created by Benjamin Garrigues on 04/09/2017.

import UIKit

class ViewController: UIViewController {

    //MARK: - View properties
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    //MARK: - Data properties
    var engine: EVCEngine? = nil {
        didSet {
            engine?.sampleService.register(observer: self)
        }
    }


    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Because this sample uses a Storyboard to create its root view controller,
        //we need to grab the engine on the appdelegate from here.
        engine = (UIApplication.shared.delegate as? AppDelegate)?.engine
        updateViews()
    }


    //MARK: View rendering
    fileprivate func updateViews() {
        loadingIndicator.stopAnimating()
        
        if let value = engine?.sampleService.currentSampleData?.value {
            label.text = String(value)
        } else {
            label.text =  "No data yet"
        }
    }


    //MARK: - Actions
    @IBAction func onTapCallSampleService(_ sender: Any) {
        loadingIndicator.startAnimating()
        engine?.sampleService.refreshData(onError: { [weak self](error) in
            self?.loadingIndicator.stopAnimating()
            if let error = error {
                let alertController = UIAlertController(title: "Error", message:
                    error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        })
    }

}


//MARK: - SampleServiceObserver.
//Whenever the data change, we rerender the whole view.
//This single refresh loop is the easiest way to keep your screen updated in a consistant manner.
//You should start thinking about refreshing parts of your screen only if performance is an issue.
extension ViewController : SampleServiceObserver {
    func onSampleService(_ service: SampleService, didUpdateSampleDataTo newValue: SampleModel?) {
        self.updateViews()
    }
}

