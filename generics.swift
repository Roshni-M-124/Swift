//: [Previous](@previous)

import Foundation

//generic types

enum StackError: Error {
    case Empty(message: String)
}

public struct Stack<T> {
    var array: [T] = []
    init(capacity: Int) {
        array.reserveCapacity(capacity)
    }
    public mutating func push(element: T) {
        array.append(element)
    }
    public mutating func pop() -> T? {
        return array.popLast()
    }
    public func peek() throws -> T {
        guard !isEmpty(), let lastElement = array.last else {
            throw StackError.Empty(message: "Array is empty")
        }
        return lastElement
    }
    func isEmpty() -> Bool {
        return array.isEmpty
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
        let elements = array.map{ "\($0)" }.joined(separator: "\n")
        return elements
    }
}

var stack = Stack<Int>(capacity: 10)
stack.push(element: 1)
stack.push(element: 2)
print(stack)
var strigStack = Stack<String>(capacity: 10)
strigStack.push(element: "aaina")
print(strigStack)

//generic type constraints

func min<T: Comparable>(_ x: T, _ y: T) -> T {
       return y < x ? y : x
}

print(min(3,5))

//associated types

protocol Stackable {
    associatedtype Element
    mutating func push(element: Element)
    mutating func pop() -> Element?
    func peek() throws -> Element
    func isEmpty() -> Bool
    func count() -> Int
    subscript(i: Int) -> Element { get }
}

enum StackError1: Error {
    case Empty(message: String)
}

public struct Stack1<T>: Stackable {
    public typealias Element = T
    
    var array: [T] = []
    
    init(capacity: Int) {
        array.reserveCapacity(capacity)
    }
    
    public mutating func push(element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public func peek() throws -> T {
        guard !isEmpty(), let lastElement = array.last else {
            throw StackError.Empty(message: "Array is empty")
        }
        return lastElement
    }
    
    func isEmpty() -> Bool {
       return array.isEmpty
    }
    
    func count() -> Int {
        return array.count
    }
}

extension Stack1: Collection {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
    
    public subscript(i: Int) -> T {
        return array[i]
    }
    
    public var startIndex: Int {
        return array.startIndex
    }
    
    public var endIndex: Int {
        return array.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }
}

extension Stack1: CustomStringConvertible {
    public var description: String {
        let header = "***Stack Operations start*** "
        let footer = " ***Stack Operation end***"
        let elements = array.map{ "\($0)" }.joined(separator: "\n")
        return header + elements + footer
    }
}

var stack1 = Stack1<Int>(capacity: 10)
stack1.push(element: 1)
stack1.pop()
stack1.push(element: 3)
stack1.push(element: 4)
print(stack1)

func swapM<T>(_ a:inout T,_ b:inout T){
    let temp = a
    a = b
    b = temp
    print(a,b)
}
var someInt = 3
var anotherInt = 107
swapM(&someInt, &anotherInt)
var someString = "hello"
var anotherString = "world"
swapM(&someString, &anotherString)

func getValue<U: Hashable, V>(from dict: [U: V], key: U) -> V? {
    return dict[key]
}
let ages = ["Alice": 25, "Bob": 30]
if let age = getValue(from: ages, key: "Alice") {
    print(age)   // 25
}

func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
//let doubleIndex = findIndex(of: "hi", in: [3.14159, 0.1, 0.25])//error-cannot convert value of type string to double arises cause of Equatable

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer
        where Suffix.Item == Item
    
    func suffix(_ size: Int) -> Suffix
}

struct Stack2<Element>: SuffixableContainer {
    var items: [Element] = []
    
    mutating func append(_ item: Element) {
        items.append(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
    
    func suffix(_ size: Int) -> Stack2<Element> {
        var result = Stack2<Element>()
        
        for i in (count - size)..<count {
            result.append(items[i])
        }
        
        return result
    }
}

var stack2 = Stack2<Int>()

stack2.append(10)
stack2.append(20)
stack2.append(30)
stack2.append(40)
let lastTwo = stack2.suffix(2)
print(lastTwo.items)

//generic where clauses

extension Array: Container {}
func allItemsMatch<C1: Container, C2: Container>
(_ c1: C1, _ c2: C2) -> Bool
where C1.Item == C2.Item, C1.Item: Equatable {
    
    if c1.count != c2.count {
        return false
    }
    
    for i in 0..<c1.count {
        if c1[i] != c2[i] {
            return false
        }
    }
    
    return true
}
let a = [1, 2, 3]
let b = [1, 2, 3]
print(allItemsMatch(a, b))  // true
print(allItemsMatch(a, stack2))

//extension with generic where clause
struct Stack3<Element> {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
}
extension Stack3 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        return items.last == item
    }
}
var stack3 = Stack3<Int>()
stack3.push(10)
stack3.push(20)
print(stack3.isTop(20))  // true

//constraint to specific type

extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        
        for i in 0..<count {
            sum += self[i]
        }
        
        return sum / Double(count)
    }
}
let values: [Double] = [10.0, 20.0, 30.0]
print(values.average()) // 20.0
let ints = [1, 2, 3]
// ints.average() // Error

//contextual where clause - apply constraint per method

extension Container {
    
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count > 0 && self[count - 1] == item
    }
    
    func average() -> Double where Item == Int {
        var sum = 0.0
        
        for i in 0..<count {
            sum += Double(self[i])
        }
        
        return sum / Double(count)
    }
}
let nums = [1, 2, 3]
print(nums.endsWith(3))  // true
print(nums.average())    // 2.0

extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Element == Int {
        
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}

let arr = ["a", "b", "c", "d"]
let result = arr[[0, 2, 3]]
print(result)
