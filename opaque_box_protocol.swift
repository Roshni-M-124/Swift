import Foundation

protocol Animal {
    func sound() -> String
}

struct Dog: Animal {
    func sound() -> String { "Bark" }
}

struct Cat: Animal {
    func sound() -> String { "Meow" }
}

func getAnimal() -> some Animal {
    return Dog()
}

let a = getAnimal()
print(a.sound())

func getAnimal1(flag: Bool) -> some Animal {
   // if flag {
        return Dog()
    //}
        /*else {
        return Cat() //  different type
    }*/
}

func getAnimal(flag: Bool) -> any Animal {
    if flag {
        return Dog()
    } else {
        return Cat()
    }
}

let b = getAnimal(flag: true)
print(b.sound())
