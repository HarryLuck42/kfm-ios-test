//
//  MainViewController.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 09/11/21.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelDirection: UILabel!
    
    @IBOutlet weak var cityNotFoundView: UIView!
    @IBOutlet weak var windView: UIStackView!
    @IBOutlet weak var imageNotFound: UIImageView!
    @IBOutlet weak var labelNotFound: UILabel!
    
    let language = Constants.language
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewLoad()
        observeViewModel()
    }
    
    private func initViewLoad(){
        
    }
    
    private func observeViewModel(){
        
        
        
        viewModel.error.asObservable().subscribe(onNext: { [weak self] (error) in
            guard let e = error else { return }
            self?.handleAPIError(error: e)
            switch e{
            case .emptyError:
                self?.setImage(isNotFound: true)
                self?.cityNotFoundView.isHidden = false
            default:
                print("Error")
            }
            
        }).disposed(by: disposeBag)
        
        
        viewModel.searchCity.asObservable().subscribe(onNext: { [weak self] result in
            guard let city = result else { return }
            
            self?.viewModel.getWeather(key: city.key ?? "")
            self?.labelCity.isHidden = false
            self?.labelCity.text = city.name
        }).disposed(by: disposeBag)
        
        viewModel.weather.asObservable().subscribe(onNext: { [weak self] result in
            guard let weather = result else { return }
            
            
            self?.updateValue(weather: weather)
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateValue(weather: Weather){
        if let url = URL(string: weather.urlIcon){
            imageWeather.isHidden = false
            imageWeather.downloadWithTransition(image: url, imgPlaceHolder: "ic_weather_placeholder")
        }
        if let wind = weather.wind{
            
            if let speed = wind.speed, let direction = wind.direction{
                if let sValue = speed.value, let sUnit = speed.unit, let dValue = direction.degree,
                   let dDirection = direction.direction{
                    windView.isHidden = false
                    labelSpeed.text = "\(sValue)\(sUnit)"
                    labelDirection.text = "\(dDirection) \(dValue)°"
                }
            }
        }
        
        if let temp = weather.temperature{
            labelTemperature.isHidden = false
            if let value = temp.value, let unit = temp.unit{
                labelTemperature.text = "\(String(value))°\(unit)"
            }
        }else{
            labelTemperature.isHidden = true
        }
        
        labelDate.text = weather.date
        labelDate.isHidden = false
        labelTime.text = weather.time
        labelTime.isHidden = false
        
        if let value = weather.iconPhrase{
            labelWeather.text = value
            labelWeather.isHidden = false
        }
    }
    
    private func resetValue(){
        labelCity.text = ""
        labelCity.isHidden = true
        labelTemperature.text = ""
        labelTemperature.isHidden = true
        labelDate.text = ""
        labelDate.isHidden = true
        labelTime.text = ""
        labelTime.isHidden = true
        labelWeather.text = ""
        labelWeather.isHidden = true
        cityNotFoundView.isHidden = true
        imageWeather.isHidden = true
        windView.isHidden = true
    }
    
    private func setImage(isNotFound: Bool){
        if isNotFound{
            imageNotFound.image = UIImage(named: "ic_not_found")
            labelNotFound.text = "The City is Not Found"
        }else{
            imageNotFound.image = UIImage(named: "ic_enjoy_app")
            labelNotFound.text = "Having a whale of a time"
        }
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        let view = FilterViewController()
        view.saveHandler = { [weak self] result in
            self?.searchField.text = result.name
            self?.resetValue()
            self?.viewModel.searchCity(keyword: result.name ?? "", countryId: result.countryID ?? "")
        }
        view.show(fromViewController: self)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        if let valueSearch = searchField.text{
            if valueSearch.count > 0{
                resetValue()
                viewModel.searchCity(keyword: valueSearch)
            }else{
                self.view.makeToast("Please input the keyword of the searching")
            }
        }else{
            self.view.makeToast("Please input the keyword of the searching")
        }
        
    }
}

