import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")

public struct ComputeSquareMacro: ExpressionMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        guard let arguement = node.arguments.first?.expression,
              let literalValue = arguement.as(IntegerLiteralExprSyntax.self)?.literal.text,
              let number = Int(literalValue) else{
            throw MacroExpansionErrorMessage("Invalid arguement for computeSquare")
        }
        
        let squaredValue = number * number
        return ExprSyntax(IntegerLiteralExprSyntax(integerLiteral: squaredValue))
    }
    
}

public struct DeclareMacroExample: DeclarationMacro{
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,in context: some SwiftSyntaxMacros.MacroExpansionContext)throws -> [SwiftSyntax.DeclSyntax]{
            guard let arguement = node.arguments.first?.expression else{
                throw MacroExpansionErrorMessage("Wrong arguement")
            }
            return ["""
                struct DeclareMacroStruct{
                    static let value = \(arguement)
                }
                """]
        }
}


        
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

public struct StoringGuyMacro: AccessorMacro{
    
    public static func expansion< Context: MacroExpansionContext,Declaration: DeclSyntaxProtocol>(
        of node: AttributeSyntax, providingAccessorsOf declaration: Declaration,in context: Context)throws -> [AccessorDeclSyntax] {
            guard let varDecl = declaration.as(VariableDeclSyntax.self),let binding = varDecl.bindings.first,let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier
            else {
                return []
            }
            return [
                """
                get{
                    dict["\(raw: identifier.text)"]! as! String
                }
                """
                ,
                """
                set{
                    dict["\(raw: identifier.text)"] = newValue
                }
                """,
            ]
        }
}
    
    
@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self, ComputeSquareMacro.self,DeclareMacroExample.self,StoringGuyMacro.self
    ]
}
