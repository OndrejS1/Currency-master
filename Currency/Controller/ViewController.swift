//
//  ViewController.swift
//  Currency
//
//  Created by Robert O'Connor on 18/10/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK Model holders
    var currencyDict:Dictionary = [String:Currency]()
    var baseCurrency:Currency = Currency.init(name:"EUR", rate:1, flag:"🇪🇺", symbol:"€")!
    var lastUpdatedDate: Date = Date()
    var convertValue:Double = 0
    
    @IBOutlet weak var aIndicator: UIActivityIndicatorView!
    //MARK Outlets
    //@IBOutlet weak var convertedLabel: UILabel!
    // Base currency EUR
    @IBOutlet weak var baseSymbol: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var baseFlag: UILabel!
    
    // Date label
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    // GBP
    @IBOutlet weak var gbpSymbolLabel: UILabel!
    @IBOutlet weak var gbpValueLabel: UILabel!
    @IBOutlet weak var gbpFlagLabel: UILabel!
    
    
    // USD
    @IBOutlet weak var usdSymbolLabel: UILabel!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var usdFlagLabel: UILabel!
    
    // KRW
    
    @IBOutlet weak var krwSymbolLabel: UILabel!
    
    @IBOutlet weak var krwValueLabel: UILabel!
    
    @IBOutlet weak var krwFlagLabel: UILabel!
    
    
    
    // CZK
    
    @IBOutlet weak var czkSymbolLabel: UILabel!
    
    @IBOutlet weak var czkValueLabel: UILabel!
    
    
    @IBOutlet weak var czkFlagLabel: UILabel!
    
    
    //AUD
    
    @IBOutlet weak var audSymbolLabel: UILabel!
    
    @IBOutlet weak var audValueLabel: UILabel!
    
    @IBOutlet weak var audFlagLabel: UILabel!
    
    // BRN
    
    @IBOutlet weak var bgnSymbolLabel: UILabel!
    
    @IBOutlet weak var bgnValueLabel: UILabel!
    
    @IBOutlet weak var bgnFlagLabel: UILabel!
    
    
    @IBAction func refreshCurrency(_ sender: Any) {
        
            self.setupCurrency()
        
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create currency dictionary
        self.createCurrencyDictionary()
        
        // get latest currency values
        self.baseTextField.delegate = self
        self.setupCurrency()
        self.displayCurrencyInfo()
         convertValue = 1
         // set up base currency screen items
        baseTextField.text = String(format: "%.02f", baseCurrency.rate)
        baseSymbol.text = baseCurrency.symbol
        baseFlag.text = baseCurrency.flag
        
        // set up last updated date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        // display currency info
        
        
        // setup view mover
        baseTextField.delegate = self
        self.convert(self)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCurrencyDictionary(){
        
        currencyDict["CZK"] = Currency(name:"CZK", rate: 1, flag:"🇨🇿", symbol: "CZK")
        currencyDict["AUD"] = Currency(name:"AUD", rate:1, flag:"🇳🇿", symbol: "A$")
        currencyDict["BGN"] = Currency(name:"BGN", rate: 1, flag:"🇧🇬", symbol: "BGN")
        currencyDict["KRW"] = Currency(name:"KRW", rate:1, flag:"🇰🇷", symbol: "₩")
         currencyDict["GBP"] = Currency(name:"GBP", rate: 1, flag:"🇬🇧", symbol: "£")
        currencyDict["USD"] = Currency(name:"USD", rate:1, flag:"🇺🇸", symbol: "$")
        
        gbpFlagLabel.text = self.currencyDict["GBP"]?.flag
        czkFlagLabel.text = self.currencyDict["CZK"]?.flag
        bgnFlagLabel.text = self.currencyDict["BGN"]?.flag
        krwFlagLabel.text = self.currencyDict["KRW"]?.flag
        audFlagLabel.text = self.currencyDict["AUD"]?.flag
        usdFlagLabel.text = self.currencyDict["USD"]?.flag
        
        gbpSymbolLabel.text = self.currencyDict["GBP"]?.symbol
        czkSymbolLabel.text = self.currencyDict["CZK"]?.symbol
        bgnSymbolLabel.text = self.currencyDict["BGN"]?.symbol
        audSymbolLabel.text = self.currencyDict["AUD"]?.symbol
        krwSymbolLabel.text = self.currencyDict["KRW"]?.symbol
        usdSymbolLabel.text = self.currencyDict["USD"]?.symbol
        
       
        
        
    }
    
    
    func displayCurrencyInfo() {
        // GBP
        if let c = currencyDict["GBP"]{
            gbpSymbolLabel.text = c.symbol
            gbpValueLabel.text = String(format: "%.02f", c.rate)
            gbpFlagLabel.text = c.flag
        }
        
        // USD
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        // CZK
        if let c = currencyDict["CZK"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        // KRW
        if let c = currencyDict["KRW"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        // BRN
        if let c = currencyDict["BGN"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        
        // AUD
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        
    }
    
    func getConversionTable() {
        //var result = "<NOTHING>"
        aIndicator.startAnimating()
       aIndicator.isHidden = false
        
        let urlStr:String = "https://api.fixer.io/latest"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if error == nil{
                print(response!)
                
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    print(jsonDict)
                    
                    if let ratesData = jsonDict["rates"] as? NSDictionary {
                        print(ratesData)
                        for rate in ratesData{
                            //print("#####")
                            let name = String(describing: rate.key)
                            let rate = (rate.value as? NSNumber)?.doubleValue
                            let flag = " "
                            let symbol = " "
                            switch(name){
                            case "USD":
                                
                                let c:Currency  = self.currencyDict["USD"]!
                                c.rate = rate!
                                self.currencyDict["USD"] = c
                                
                            case "GBP":
                                
                                let c:Currency  = self.currencyDict["GBP"]!
                            
                                c.rate = rate!
                                self.currencyDict["GBP"] = c
                            case "CZK":
                                let c: Currency = self.currencyDict["CZK"]!
                                c.rate = rate!
                                
                                self.currencyDict["CZK"] = c
                                
                            case "AUD":
                                let c: Currency = self.currencyDict["AUD"]!
                                c.rate = rate!
                                
                                self.currencyDict["AUD"] = c
                                
                                
                            case "BGN":
                                let c: Currency = self.currencyDict["BGN"]!
                                c.rate = rate!
                                
                                self.currencyDict["BGN"] = c
                                
                            case "KRW":
                                let c: Currency = self.currencyDict["KRW"]!
                                c.rate = rate!
                                
                                self.currencyDict["KRW"] = c
                            default:
                                
                                print("Ignoring currency: \(String(describing: rate))")
                            }
                            
                            
                            let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
                            self.currencyDict[name] = c
                            
                        }
                        self.lastUpdatedDate = Date()
                       
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
            else{
                print("Error")
            }
            
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.aIndicator.stopAnimating()
            self.aIndicator.isHidden = true
        }
        task.resume()
     
        
    }

    
    @IBAction func convert(_ sender: Any) {
        
        convertCurrency()
    }
    
    func convertCurrency() {
        
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultCZK = 0.0
        var resultKRW = 0.0
        var resultAUD = 0.0
        var resultBGN = 0.0
        
        
        if let euro = Double(baseTextField.text!) {
            convertValue = euro
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
                
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            
            if let czk = self.currencyDict["CZK"] {
                resultCZK = convertValue * czk.rate
            }
            
            if let krw = self.currencyDict["KRW"] {
                resultKRW = convertValue * krw.rate
            }
            
            if let bgn = self.currencyDict["BGN"] {
                resultBGN = convertValue * bgn.rate
            }
            
            if let aud = self.currencyDict["AUD"] {
                resultAUD = convertValue * aud.rate
            }
            
        }
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        czkValueLabel.text = String(format: "%.02f", resultCZK)
        audValueLabel.text = String(format: "%.02f", resultAUD)
        bgnValueLabel.text = String(format: "%.02f", resultBGN)
        krwValueLabel.text = String(format: "%.02f", resultKRW)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        
        
    }
    
    func setupCurrency() {
        
        getConversionTable()
        baseTextField.text = "1.00"
        baseCurrency.rate = 1
        convertCurrency()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true )
    }
    
   
   
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
    
}

