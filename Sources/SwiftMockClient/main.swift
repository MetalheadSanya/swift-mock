import SwiftMock
import SwiftSyntax
import SwiftParser

//@Mock
//public protocol Test {
//	func call()
//}

func inspect(_ node: Syntax) {
	print(node.debugDescription)
}

let needToFigureOut =
  """
	var test: Int { get }
	"""
let parsed = SwiftParser.Parser.parse(source: needToFigureOut)
inspect(Syntax(parsed))
