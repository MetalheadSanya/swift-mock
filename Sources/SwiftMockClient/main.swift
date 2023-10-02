import SwiftMock
import SwiftSyntax
import SwiftParser

@Mock
public protocol Test {
	func call()
}

func inspect(_ node: Syntax) {
	print(node.debugDescription)
}

let needToFigureOut =
  """
	func $call(argument: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int), Void> {
		MethodSignature<(Int), Void>(ArgumentMatcher: any(), register: {
			self.call_argument_.append($0)
		})
	}
	"""
let parsed = SwiftParser.Parser.parse(source: needToFigureOut)
inspect(Syntax(parsed))
