//
//  FilterViewController.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import UIKit
import RxSwift
import DropDown
import Toast_Swift

class FilterViewController: UIViewController {

    @IBOutlet weak var labelRegion: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelArea: UILabel!
    
    @IBOutlet weak var viewRegion: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewArea: UIView!
    
    @IBOutlet weak var progressFilter: UIActivityIndicatorView!
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var dropDownRegions = DropDown()
    private var dropDownCountries = DropDown()
    private var dropDownAreas = DropDown()
    private var fixArea: Region? = nil
    
    var saveHandler: ((Region) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewInit()
        observeViewModel()
    }
    
    private func viewInit(){
        viewRegion.isHidden = true
        viewModel.getRegions()
        let gestureRegion = UITapGestureRecognizer(target: self, action: #selector(getRegions))
        let gestureCountry = UITapGestureRecognizer(target: self, action: #selector(getCountries))
        let gestureArea = UITapGestureRecognizer(target: self, action: #selector(getAreas))
        
        viewRegion.addGestureRecognizer(gestureRegion)
        viewRegion.isUserInteractionEnabled = true
        viewCountry.addGestureRecognizer(gestureCountry)
        viewCountry.isUserInteractionEnabled = true
        viewArea.addGestureRecognizer(gestureArea)
        viewArea.isUserInteractionEnabled = true
        
        dropDownRegions.accessibilityIdentifier = "dropDownRegions"
        dropDownRegions.selectionAction = { [weak self] index, value in
            if let code = self?.viewModel.regions.value?[index].id{
                self?.viewModel.getCountries(code: code)
                self?.setRegions(value: value)
            }
            
        }
        
        dropDownCountries.accessibilityIdentifier = "dropDownCountries"
        dropDownCountries.selectionAction = { [weak self] index, value in
            if let code = self?.viewModel.countries.value?[index].id{
                self?.viewModel.getAreas(code: code)
                self?.setCountries(value: value)
            }
        }
        
        dropDownAreas.accessibilityIdentifier = "dropDownAreas"
        dropDownAreas.selectionAction = { [weak self] index, value in
            if let data = self?.viewModel.areas.value?[index]{
                self?.setArea(value: data)
            }
            
        }
    }
    
    private func observeViewModel(){
        viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] state in
            if state{
                self?.progressFilter.startAnimating()
                self?.progressFilter.isHidden = false
            }else{
                self?.progressFilter.stopAnimating()
                self?.progressFilter.isHidden = true
            }
            
        }).disposed(by: disposeBag)
        viewModel.regions.asObservable().subscribe(onNext: {[weak self] regions in
            if let results = regions{
                if results.count > 0{
                    for data in results{
                        self?.dropDownRegions.dataSource.append(data.name ?? "")
                    }
                    self?.viewRegion.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
        viewModel.countries.asObservable().subscribe(onNext: {[weak self] countries in
            if let results = countries{
                if results.count > 0{
                    for data in results{
                        self?.dropDownCountries.dataSource.append(data.name ?? "")
                    }
                    self?.viewCountry.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
        viewModel.areas.asObservable().subscribe(onNext: {[weak self] areas in
            if let results = areas{
                if results.count > 0{
                    for data in results{
                        self?.dropDownAreas.dataSource.append(data.name ?? "")
                    }
                    self?.viewArea.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @objc private func getRegions(){
        dropDownRegions.anchorView = viewRegion.superview?.superview
        dropDownRegions.show()
        resetCountries()
        resetAreas()
    }
    
    private func resetRegions(){
        viewRegion.isHidden = true
        dropDownRegions.dataSource = []
        labelRegion.text = "Region"
        labelRegion.textColor = UIColor.systemGray
    }
    
    private func setRegions(value: String){
        labelRegion.text = value
        labelRegion.textColor = UIColor.black
    }
    
    @objc private func getCountries(){
        dropDownCountries.anchorView = viewRegion.superview?.superview
        dropDownCountries.show()
        resetAreas()
    }
    
    private func resetCountries(){
        viewCountry.isHidden = true
        dropDownCountries.dataSource = []
        labelCountry.text = "Country"
        labelCountry.textColor = UIColor.systemGray
    }
    
    private func setCountries(value: String){
        labelCountry.text = value
        labelCountry.textColor = UIColor.black
    }
    
    @objc private func getAreas(){
        dropDownAreas.anchorView = viewRegion.superview?.superview
        dropDownAreas.show()
    }
    
    private func resetAreas(){
        viewArea.isHidden = true
        dropDownAreas.dataSource = []
        labelArea.text = "Area"
        labelArea.textColor = UIColor.systemGray
        fixArea = nil
    }
    
    private func setArea(value: Region){
        fixArea = value
        labelArea.text = value.name
        labelArea.textColor = UIColor.black
    }

    @IBAction func closeFilter(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func filterWeather(_ sender: UIButton) {
        if let handler = saveHandler{
            if let data = fixArea{
                handler(data)
                hide()
            }else{
                self.view.makeToast("Please input the city first before you submit your filter!")
            }
        }
    }
    
    func show(fromViewController source: UIViewController) {
      self.view.frame = (source.view.window?.bounds)!
      
      self.view.backgroundColor = UIColor.clear
      let firstChild = self.view.subviews[0]
      firstChild.transform = CGAffineTransform(translationX: 0, y: 500)
      firstChild.alpha = 0
      
      source.view.window?.addSubview(self.view)
      source.addChild(self)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .beginFromCurrentState, animations: {
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        let firstChild = self.view.subviews[0]
        firstChild.transform = CGAffineTransform.identity
        firstChild.alpha = 1
        
      }) { (finished) in
        self.didMove(toParent: source)
      }
    }
    
    func hide() {
      UIView.animate(withDuration: 0.25, animations: {
        self.view.backgroundColor = UIColor.clear
        let firstChild = self.view.subviews[0]
        firstChild.transform = CGAffineTransform(translationX: 0, y: -50)
        firstChild.alpha = 0
        
      }, completion: { (finished) in
        self.view.removeFromSuperview()
        self.removeFromParent()
      })
    }
    

}
