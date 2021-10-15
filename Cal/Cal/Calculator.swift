//
//  Calculator.swift
//  Cal
//
//  Created by wangxuan on 2021/10/07.
//  Copyright © 2021 wangxuan. All rights reserved.
//

import UIKit
import Darwin
let e = Darwin.M_E
var mem:Double = 0.0
var deg_touched:Bool = false

class Calculator: NSObject {
    
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double)->Double)
        case EqualOp
        case Constant(Double)
    }
    
    var operations = [
        "+": Operation.BinaryOp{
            (op1, op2) in
            return op1 + op2
        },
            
        "-": Operation.BinaryOp{
            (op1, op2) in
            return op1 - op2
        },
        
        "x": Operation.BinaryOp{
            (op1, op2) in
            return op1 * op2
        },
        
        "/": Operation.BinaryOp{
            (op1, op2) in
            if op2 == 0{
                return Double.nan
            }
            return op1 / op2
        },//除零的情况
        
        "=": Operation.EqualOp,
        
        "%": Operation.UnaryOp{
            op in
            return op / 100.0
        },
        
        "⁺⁄₋": Operation.UnaryOp{
            op in
            return -op
        },
        
        "mc":Operation.UnaryOp{
            op in
            mem = 0.0;
            return op
        },
        
        "m+":Operation.UnaryOp{
            op in
            mem += op;
            return op
        },
        
        "m-":Operation.UnaryOp{
            op in
            mem  -= op;
            return op
        },
        
        "mr":Operation.Constant(mem),
        
        "x²": Operation.UnaryOp{
            op in
            return pow(op,2)
        },
        
        "x³": Operation.UnaryOp{
            op in
            return pow(op,3)
        },
        
        "xʸ": Operation.BinaryOp{
            (op1, op2) in
            return pow(op1,op2)
        },
        
        "eˣ": Operation.UnaryOp{
            op in
            return pow(e,op)
        },
        
        "10ˣ": Operation.UnaryOp{
            op in
            return pow(10,op)
        },
        
        "²√x": Operation.UnaryOp{
            op in
            if op < 0{
                return Double.nan
            }
            return sqrt(op)
        },//正数
        
        "³√x": Operation.UnaryOp{
            op in
            return pow(op, 1.0/3.0)
        },
        
        "ʸ√x": Operation.BinaryOp{
            (op1, op2) in
            if op2 == 0 || (Int(abs(op2))%2==0&&op1<0){
                return Double.nan
            }
            return pow(op1, 1.0/op2)
        },
        
        "x!": Operation.UnaryOp{
            op in
            let toInt = floor(op)
            if toInt != op || toInt < 0{
                return Double.nan
            }
            guard op != 0 else {
                return 1
            }
            return Double((1...Int(op)).reduce(1, { $0 * $1 }))
        },
        
        "sin": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return sin(op * Double.pi / 180)
            }
            else{
                return sin(op)
            }
        },
        
        "cos": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return cos(op * Double.pi / 180)
            }
            else{
                return cos(op)
            }
        },
        
        "tan": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return tan(op * Double.pi / 180)
            }
            else{
                return tan(op)
            }
        },
        
        "sin⁻¹": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return asin(op)/Double.pi * 180
            }
            else{
                return asin(op)
            }
        },
        
        "cos⁻¹": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return acos(op)/Double.pi * 180
            }
            else {
                return acos(op)
            }
        },
        
        "tan⁻¹": Operation.UnaryOp{
            op in
            if deg_touched == false{
                return atan(op)/Double.pi * 180
            }
            else{
                return atan(op)
            }
        },
        
        "e": Operation.Constant(e),//长度精度问题
        
        "EE": Operation.BinaryOp{
            (op1, op2) in
            return op1 * pow(10, op2)
        },
        
        "log₁₀": Operation.UnaryOp{
            op in
            if op <= 0{
                return Double.nan
            }
            return log10(op)
        },//正数
        
        "ln": Operation.UnaryOp{
            op in
            if op <= 0{
                return Double.nan
            }
            return log(op)
        },//正数
        
        "¹⁄ₓ": Operation.UnaryOp{
            op in
            if op == 0{
                return Double.nan
            }
            return 1.0 / op
        },
        
        "sinh": Operation.UnaryOp{
            op in
            return sinh(op)
        },
        
        "cosh": Operation.UnaryOp{
            op in
            return cosh(op)
        },
        
        "tanh": Operation.UnaryOp{
            op in
            return tanh(op)
        },
        
        "asinh":Operation.UnaryOp{
            op in
            if deg_touched == false{
                return asinh(op)
            }
            else{
                return asinh(op/180.0 * .pi)
            }
        },
        "acosh":Operation.UnaryOp{ op in
            if(op<1){
                return Double.nan
            }
            if deg_touched == false{
                return acosh(op)
            }
            else{
                return acosh(op/180.0 * .pi)
            }
        },
        "atanh":Operation.UnaryOp{ op in
            if(op < 0 || op > 1){
                return Double.nan
            }
            if deg_touched == false{
                return atanh(op)
            }
            else{
                return atanh(op/180.0 * .pi)
            }
        },
        
        "yˣ":Operation.BinaryOp{
            op1, op2 in
            return pow(op2,op1)
        },
        
        "2ˣ":Operation.UnaryOp{
            op in
            return pow(2,op)
        },
        
        "logy":Operation.BinaryOp{
            op1,op2 in
            if(op1 <= 0 || op2 <= 0){
                return Double.nan
            }
            return log(op1)/log(op2)
        },
        
        "log2":Operation.UnaryOp{
            op in
            if(op<=0){
                return Double.nan
            }
            return log2(op)
        },
        
        "π": Operation.Constant(M_PI),
        
        "Rand": Operation.UnaryOp{
            op in
            return Double.random(in: 0..<1)
        }//单个操作数还是常量
    
    ]
    
    struct Intermediate{
        var firstOp: Double
        var waitingOperation: (Double, Double) -> Double
    }
    
    var stackOp = [Intermediate]()
    var pendingOp: Intermediate? = nil
    
    func performOperation(operation: String, operand: Double)->Double?{
        if let op = operations[operation]{
            var res:Double? = nil
            switch op{
            case .BinaryOp(let function):
                if pendingOp != nil{
                    res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                    pendingOp = Intermediate(firstOp: res!, waitingOperation: function)
                    return res
                }
                else{
                    pendingOp = Intermediate(firstOp: operand, waitingOperation: function)
                }
                return nil
            case .Constant(let value):
                return value
            case .EqualOp:
                if pendingOp != nil{
                    res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                    pendingOp = nil
                }
                return res
            case .UnaryOp(let function):
                res = function(operand)
                return (res! * 10000000).rounded() / 10000000
            }
        }
       else if operation == "("{
            if pendingOp != nil{
                stackOp.append(pendingOp!)
                pendingOp = nil
            }
        }
        else if operation == ")"{
            var res:Double? = nil
            if pendingOp != nil{
                res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                if stackOp.isEmpty == false{
                    pendingOp = stackOp.removeLast()
                }
                else{
                    pendingOp = nil
                }
            }
            
            return res
        }
        else if operation == "C"{
            //pendingOp = nil
            return 0
        }
        else if operation == "AC"{
            pendingOp = nil
            return 0
        }
        else if operation == "Deg"{
            deg_touched = false
        }
        else if operation == "Rad"{
            deg_touched = true
        }
        return nil
    }
}
