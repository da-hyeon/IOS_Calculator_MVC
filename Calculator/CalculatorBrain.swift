//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 황다현 on 15/01/2019.
//  Copyright © 2019 HDH. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accmulator = 0.0
    private var internalProgram = [AnyObject]()
    
    
    func setOperand( operand : Double ) {
        accmulator = operand
        internalProgram.append(operand as AnyObject)
        print("accmulator를 입력한 숫자로 초기화")
    }
    
    private var operations : Dictionary<String , Operation> = [
        "π" : .Constant(M_PI) ,
        "e" : .Constant(M_E) ,
        "√" : .UnaryOperation(sqrt) ,
        "cos" : .UnaryOperation(cos) ,
        "×" : .BinaryOperation({ $0 * $1 }),
        "÷" : .BinaryOperation({ $0 / $1 }),
        "+" : .BinaryOperation({ $0 + $1 }),
        "−" : .BinaryOperation({ $0 - $1 }),
        "=" : .Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)     //Double을 받아서 Double을 반환
        case BinaryOperation((Double , Double) -> Double)
        case Equals
        
    }
    
    func performOperation( symbol: String ) {
        print("performOperation에 터치한 \(symbol)연산버튼을 받음")
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
             print("현재 진행대기중인 연산은 \(operation)")
            switch operation {
            case .Constant(let value) :
                accmulator = value
                print(value)
                
            case .UnaryOperation(let function) :
                accmulator = function(accmulator)
                
            case .BinaryOperation(let function) :
                executePendingBinaryOperationInfo()
                print("BeforePending : \(Pending)")
                Pending = PendingBinaryOperationInfo(binaryFunction: function, fiistOperand: accmulator)
                print("AfterPending : \(Pending!)")
            case .Equals :
                executePendingBinaryOperationInfo()
            }
        }
    }
    
    private func executePendingBinaryOperationInfo() {
        print("executePendingBinaryOperationInfo 메소드 진입")
        if Pending != nil {
            print("Pending이 nil이 아니여서 진입했고  \(Pending!.fiistOperand) , \(accmulator)이다.")
            accmulator = Pending!.binaryFunction(Pending!.fiistOperand , accmulator)

            Pending = nil
        }
    }
    
    private var Pending : PendingBinaryOperationInfo?
    
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction : (Double , Double) -> Double
        var fiistOperand : Double
    }
    
    //typealias는 타입을 만들게 해줌. (문서화의 일종)
    typealias propertList = AnyObject
    var program : propertList{
        get {
            return internalProgram as CalculatorBrain.propertList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accmulator = 0.0
        Pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double {
        get {
            return accmulator
        }
    }
}
