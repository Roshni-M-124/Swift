//: [Previous](@previous)

import Foundation

// conform to one protocol
protocol MyProtocol1{
    func myMethod()
}

class MyClass: MyProtocol1{
    func myMethod() {
        print("Hello World!")
    }
}

//conform to multiple protocols

protocol Myprotocol2{
    func method()
}

class MyClass2: MyProtocol1, Myprotocol2{
    func method() {
        print("method")
    }
    func myMethod() {
        print("myMethod")
    }
}

//protocol extension - provide default implementation for methods in protocols.Types conforming to the protocol gets these default implementations unless they provide their own.


extension MyProtocol1{
    func defaultMethod(){
        print("defaultMethod")
    }
}

let obj = MyClass()
obj.myMethod()
obj.defaultMethod()

if obj is MyProtocol1{
    print("obj conforms to MyProtocol1")
}

//protocol composition

typealias CombinedProtocol = MyProtocol1 & Myprotocol2

class Class:CombinedProtocol{
    func method(){
        print("method")
    }
    func myMethod() {
        print("myMethod")
    }
}

//generic protocol

protocol GenericProtocol{
    associatedtype MyType
    func processValue(_ value : MyType)
}

struct StringProcessor:GenericProtocol{
    typealias MyType = String
    func processValue(_ value: String) {
        print("Processing \(value)")
    }
}

let obj2 = StringProcessor()
obj2.processValue("Hello") // protocol witness - the call to processValue is a protocol witness, using the specific implementation provided by the `obj2` instance.

//delegate

protocol HomeworkDelegate: AnyObject {
    func doHomework()
}
class Student {
    weak var delegate: HomeworkDelegate?
    func askForHelp() {
        print("Student: I need help with homework")
        delegate?.doHomework()
    }
}

class Friend: HomeworkDelegate {
    func doHomework() {
        print("Friend: I am doing your homework")
    }
}
let student = Student()
let friend = Friend()
student.delegate = friend
student.askForHelp()

//mutating methods

protocol Switchable {
    mutating func toggle()
}
enum Light: Switchable {
    case on, off
    mutating func toggle() {
        self = (self == .on) ? .off : .on
    }
}
 var e = Light.on
e.toggle()
print(e)

//intializers

protocol Buildable {
    init(name: String)
}

class Car: Buildable {
    var name: String
    required init(name: String) {
        self.name = name
    }
}

// protocol as Type

protocol Animal {
    func sound()
}

struct Dog: Animal {
    func sound() {
        print("Bark")
    }
}
let pet: Animal = Dog()
pet.sound()

//conditional conformance

protocol Printable {
    func printAll()
}

extension Array: Printable where Element: CustomStringConvertible {
    func printAll() {
        for item in self {
            print(item)
        }
    }
}

let numbers = [1, 2, 3]
numbers.printAll()  // Works (Int conforms to CustomStringConvertible)

struct Test {}
let items = [Test(), Test()]
//items.printAll() - Error (Test doesn't conform)

//protocol inheritance

protocol Animal1 {
    func eat()
}
protocol Dog1: Animal1 {
    func bark()
}

struct PetDog: Dog1 {
    func eat() {
        print("Eating")
    }
    func bark() {
        print("Barking")
    }
}

//class only protocols

protocol OnlyClass: AnyObject {
    func doSomething()
}

class MyClass3: OnlyClass {
    func doSomething() {
        print("Done")
    }
}

/*struct s:OnlyClass{
    func doSomething() {
        print("doSomething")
    }
}
*/
// collection of protocol types

protocol Shape {
    func draw()
}

struct Circle: Shape {
    func draw() {
        print("Circle")
    }
}

struct Square: Shape {
    func draw() {
        print("Square")
    }
}

let shapes: [Shape] = [Circle(), Square()]
for s in shapes {
    s.draw()
}

//optional protocol requirements

@objc protocol GameDelegate {
    @objc optional func gameDidStart()
    @objc optional func gameDidEnd()
}

class Game {
    var delegate: GameDelegate?
    func start() {
        delegate?.gameDidStart?()
        print("Game Started")
    }
}

class Player: GameDelegate {
    func gameDidStart() {
        print("Player noticed game start")
    }
}

let game = Game()
let player = Player()
game.delegate = player
game.start()
//here gameDidEnd() was not implemented but didnt throw error

//constrained protocol extensions

extension Array {
    func printCount() {
        print("I have \(count) items")
    }
}

extension Array where Element == Int {
    func sum() -> Int {
        return self.reduce(0, +)
    }
}

let number = [1, 2, 3, 4]
number.printCount() //  "I have 4 items"
print(number.sum()) // 10

let names = ["Alice", "Bob"]
names.printCount()  //  "I have 2 items"
//names.sum() // Error, only works for Int


//synthesized conformance

struct Point: Equatable {
    var x: Int
    var y: Int
}

let p1 = Point(x: 10, y: 20)
let p2 = Point(x: 10, y: 20)
print(p1 == p2) // true

enum Level: Comparable {
    case beginner
    case intermediate
    case expert(Int)
}

let levels = [
    Level.expert(3),
    Level.beginner,
    Level.expert(1)
]

print(levels.sorted())

