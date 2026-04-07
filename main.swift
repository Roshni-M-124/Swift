import MyMacro

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

let squaredNumber = #computeSquare (number: 3) // Expands to 9
print(#computeSquare(number: 5))

#declareStructWithValue("Hello, World!")
assert(DeclareMacroStruct.value == "Hello, World!")

struct StoringGuyStruct{
    var dict : [AnyHashable: Any] = [:]
    @StoringGuy
    var surnameProp : String
}

var guy = StoringGuyStruct()
guy.surnameProp = "smith"
print(guy.surnameProp)
print(guy.dict)
guy.surnameProp = "Johnson"
print(guy.surnameProp)
print(guy.dict)
