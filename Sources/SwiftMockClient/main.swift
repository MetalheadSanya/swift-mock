import SwiftMock
import SwiftSyntax
import SwiftParser

public protocol Test {
	var prop: Int { get async throws }
}

func inspect(_ node: Syntax) {
	print(node.debugDescription)
}

let needToFigureOut =
  """
	var test: Int { get }
	"""
let parsed = SwiftParser.Parser.parse(source: needToFigureOut)
inspect(Syntax(parsed))
