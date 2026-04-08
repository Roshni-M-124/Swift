//: [Previous](@previous)

import Foundation

var x: UInt8 = 0b00001111
let result = ~x   // 11110000
print(String(result,radix: 2))

let a: UInt8 = 0b11111100
let b: UInt8 = 0b00111111

let res = a & b   // 00111100
print(String(res,radix:2))

let c: UInt8 = 0b10110010
let d: UInt8 = 0b01011110

 print(String(c|d,radix:2))   //11111110

print(String(c^d,radix:2))

let y :UInt8 = 4 //00000100
print(y<<1) //00001000
print(y<<2) //00010000
print(y>>2) //00000001 here y is not assigned back so y = 4 in all the above cases

var z: Int8 = -4
print(z<<1) //-8 remains negative

var max1 : Int8 = Int8.max
//max1 += 1   //  ERROR - overflow
print(max1)

x = UInt8.max
x = x &+ 1
print(x) // wraps around to 0 prevents overflow
 x = x &- 1
print(x) //255

z = Int8.min //-128
z = z &- 1
print(z) //127

// operator overloading

struct Vector2D {
    var x: Double
    var y: Double
}

extension Vector2D {
    static func + (l: Vector2D, r: Vector2D) -> Vector2D {
        return Vector2D(x: l.x + r.x, y: l.y + r.y)
    }
}
let v1 = Vector2D(x: 3, y: 1)
let v2 = Vector2D(x: 2, y: 4)

print(v1+v2)  // (5,5)

extension Vector2D {
    static prefix func - (v: Vector2D) -> Vector2D {
        return Vector2D(x: -v.x, y: -v.y)
    }
}
var v = Vector2D(x: 3, y: 4)
let neg = -v   // (-3, -4)
print(neg)

extension Vector2D {
    static func += (l: inout Vector2D, r: Vector2D) {
        l = l + r
    }
}

v = Vector2D(x: 1, y: 2)
v += Vector2D(x: 3, y: 4) //(4,6)
print(v)

extension Vector2D: Equatable {
    static func == (l: Vector2D, r: Vector2D) -> Bool {
        return l.x == r.x && l.y == r.y
    }
}
var V1 = Vector2D(x:2,y:3)
var V2 = Vector2D(x:2,y:3)
print(V1 == V2)

prefix operator +++

extension Vector2D {
    static prefix func +++ (v: inout Vector2D) -> Vector2D {
        v += v
        return v
    }
}
print(+++V2)

infix operator +-: AdditionPrecedence

extension Vector2D {
    static func +- (l: Vector2D, r: Vector2D) -> Vector2D {
        return Vector2D(x: l.x + r.x, y: l.y - r.y)
    }
}
print(V1 +- V2)
