//
//  ViewController.swift
//  Calculator
//
//  Created by 황다현 on 14/01/2019.
//  Copyright © 2019 HDH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    //유저가 타이핑중인가?
    private var userIsInTheMiddleOfTyping = false
    
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        print("숫자버튼 터치")
        //현재 눌러진 버튼의 title가져와서 digit변수에 넣어주기.
        let digit = sender.currentTitle!
        
        //만약 타이핑중이라면
        if userIsInTheMiddleOfTyping {
            //textCurrentlyInDIsplay변수에 현재 입력되어진 text를 넣어줌
            let textCurrentlyInDIsplay = display.text!
            //display.text에 현재 입력되어진 text에 눌러진 버튼을 추가 입력함. (append와 같은 느낌)
            display.text = textCurrentlyInDIsplay + digit
            print("display에 숫자추가")
        } else {
            display.text = digit
            print("display에 숫자 새로 입력")
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    private var brain = CalculatorBrain()
    

    var savedProgram: CalculatorBrain.propertList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            print("숫자버튼 터치 후 연산버튼 터치")
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        } else {
            print("숫자버튼 터치 전에 연산버튼 터치")
        }
        
        
        if let mathematicalSymbol = sender.currentTitle {
            print("performOperation에 터치한 \(mathematicalSymbol)연산버튼을 전달")
            brain.performOperation(symbol: mathematicalSymbol)
            
        }
        displayValue = brain.result
    }
}
