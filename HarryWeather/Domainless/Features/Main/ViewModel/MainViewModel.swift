//
//  MainViewModel.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 10/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel{
    private let disposeBag = DisposeBag()
    
    var isLoading: BehaviorRelay<Bool>
    var isShimmer: BehaviorRelay<Bool>
    var error: BehaviorRelay<ApiError?>
    var canLoadMore = BehaviorRelay(value: false)
    var regions: BehaviorRelay<[Region]?>
    private var regionsTemp: [Region]?{
        didSet{
            regions.accept(regionsTemp)
        }
    }
    var countries: BehaviorRelay<[Region]?>
    private var countriesTemp: [Region]?{
        didSet{
            countries.accept(countriesTemp)
        }
    }
    var areas: BehaviorRelay<[Region]?>
    private var areasTemp: [Region]?{
        didSet{
            areas.accept(areasTemp)
        }
    }
    
    var searchCity: BehaviorRelay<City?>
    var weather: BehaviorRelay<Weather?>
    
    
    
    init(){
        isLoading = BehaviorRelay(value: false)
        isShimmer = BehaviorRelay(value: true)
        error = BehaviorRelay(value: nil)
        regions = BehaviorRelay(value: nil)
        countries = BehaviorRelay(value: nil)
        areas = BehaviorRelay(value: nil)
        searchCity = BehaviorRelay(value: nil)
        weather = BehaviorRelay(value: nil)
    }
    
    
    
    func getRegions(){
        isLoading.accept(true)
        MainInterceptor.getRegions().subscribe(onNext: {[weak self] data in
            self?.regionsTemp = data
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
    
    func getCountries(code: String){
        isLoading.accept(true)
        MainInterceptor.getCountries(idRegion: code).subscribe(onNext: {[weak self] data in
            self?.countriesTemp = data
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
    
    func getAreas(code: String){
        isLoading.accept(true)
        MainInterceptor.getAreas(idCountry: code).subscribe(onNext: {[weak self] data in
            self?.areasTemp = data
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
    
    func searchCity(keyword: String, countryId: String){
        isLoading.accept(true)
        MainInterceptor.searchCity(keyword: keyword, idCountry: countryId).subscribe(onNext: {[weak self] data in
            if let city = data{
                self?.searchCity.accept(city)
            }else{
                self?.searchCity(keyword: keyword)
            }
            
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
    
    func searchCity(keyword: String){
        isLoading.accept(true)
        MainInterceptor.searchCity(keyword: keyword).subscribe(onNext: {[weak self] data in
            if let city = data{
                self?.searchCity.accept(city)
            }else{
                self?.error.accept(.emptyError(message: "City is not found!"))
            }
            
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
    
    func getWeather(key: String){
        isLoading.accept(true)
        MainInterceptor.getWeather(key: key).subscribe(onNext: {[weak self] data in
            if let weather = data{
                self?.weather.accept(weather)
            }else{
                self?.error.accept(.emptyError(message: "The weather is not detected!"))
            }
            
        }, onError: {[weak self] (er) in
            self?.error.accept(er as? ApiError)
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }, onCompleted: {[weak self] in
            self?.isLoading.accept(false)
            self?.isShimmer.accept(false)
        }).disposed(by: disposeBag)
    }
}
