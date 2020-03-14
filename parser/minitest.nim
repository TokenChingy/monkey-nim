import ../ast/ast
import ../test_utils/test_utils as test

# outline: whther be able to parse let
# expected_value: expected let statement
block let_test:
  var program = test.get_program("let x = 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let x=5;", statement.getValue)

  program = test.get_program("""
    let a = 1;
    let b = 5;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let a=1;", statement.getValue)

  statement = program.statements[1]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let b=5;", statement.getValue)

# outline: whther be able to parse return
# expected_value: expected return statement
block return_test:
  var program = test.get_program("return 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("return", statement.getTokenLiteral)
  test.eq_value(ast.nReturnStatement, statement.s_type)
  test.eq_value("return 5;", statement.getValue)

  program = test.get_program("""
    let x = 5;
    return x;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let x=5;", statement.getValue)
  statement = program.statements[1]
  test.eq_value("return", statement.getTokenLiteral)
  test.eq_value(ast.nReturnStatement, statement.s_type)
  test.eq_value("return x;", statement.getValue)

#[
# outline: whther be able to parse identifier
# expected_value: expected identifier
block identifier_test:
  var program = test.get_program("x;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

# outline: whther be able to parse integer_literal
# expected_value: expected integer_literal
block integer_literal_test:
  var program = test.get_program("5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("INT", ast.ExpressionStatement(statement).tok.t_type)
  var integer_literal = IntegerLiteral(ast.ExpressionStatement(statement).expression)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

# outline: whther be able to parse string_literal
# expected_value: expected string_literal
block string_literal_test:
  var program = test.get_program("\"kashiwara\"")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("STRING", ast.ExpressionStatement(statement).tok.t_type)
  var integer_literal = StringLiteral(ast.ExpressionStatement(statement).expression)
  test.eq_value("STRING", integer_literal.tok.t_type)
  test.eq_value("kashiwara", integer_literal.value)

# outline: whther be able to parse boolean
# expected_value: expected boolean
block boolean_test:
  var program = test.get_program("true;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var boolean = ast.Boolean(expression.expression)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("false;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  boolean = ast.Boolean(expression.expression)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse prefix_expression
# expected_value: expected prefix_expression
block prefix_expression_test:
  var program = test.get_program("!5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  var integer_literal = IntegerLiteral(prefix_expression.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("-15;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("-", prefix_expression.tok.t_type)
  test.eq_value("-", prefix_expression.operator)
  integer_literal = IntegerLiteral(prefix_expression.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(15, integer_literal.number)

  program = test.get_program("!true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  var boolean = Boolean(prefix_expression.right)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("!false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  boolean = Boolean(prefix_expression.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse infix_expression
# expected_value: expected infix_expression
block infix_expression_test:
  var program = test.get_program("5 + 5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var infix = ast.InfixExpression(expression.expression)
  test.eq_value("+", infix.tok.t_type)
  test.eq_value("+", infix.operator)
  var integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 - 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("-", infix.tok.t_type)
  test.eq_value("-", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 * 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 / 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("/", infix.tok.t_type)
  test.eq_value("/", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 > 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value(">", infix.tok.t_type)
  test.eq_value(">", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 < 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 == 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 != 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("!=", infix.tok.t_type)
  test.eq_value("!=", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("true == true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  var boolean = Boolean(infix.right)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("true != false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("!=", infix.tok.t_type)
  test.eq_value("!=", infix.operator)
  boolean = Boolean(infix.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("false == false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  boolean = Boolean(infix.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse if expression
# expected_value: expected if expression
block if_expression_test:
  var program = test.get_program("""
  if(x < y){
    x
  }
  """)

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var if_expression = ast.IfExpression(expression.expression)

  # if
  test.eq_value("if", if_expression.tok.t_type)

  # (x < y)
  var infix = ast.InfixExpression(if_expression.condition)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  var ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)
  ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)

  # { x }
  var block_statement = if_expression.consequence
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  # alternative
  block_statement = if_expression.alternative
  test.eq_value(true, block_statement == nil)

  program = test.get_program("""
  if(x < y){
    x
  }else{
    y
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  if_expression = ast.IfExpression(expression.expression)

  # if
  test.eq_value("if", if_expression.tok.t_type)

  # (x < y)
  infix = ast.InfixExpression(if_expression.condition)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)
  ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)

  # { x }
  block_statement = if_expression.consequence
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  # { y }
  block_statement = if_expression.alternative
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("y", identifier.variable_name)

# outline: whther be able to parse fn expression
# expected_value: expected fn expression
block function_expression_test:
  var program = test.get_program("""
  fn(x,  y){
    x + y;
  }
  """)

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var function_literal = ast.FunctionLiteral(expression.expression)

  # fn
  test.eq_value("FUNCTION", function_literal.tok.t_type)

  # (x, y)
  var parameters = function_literal.parameters
  test.eq_value(2, parameters[].len)
  var identifier = parameters[0]
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)
  identifier = parameters[1]
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("y", identifier.variable_name)

  # { x + y; }
  var block_statement = function_literal.body
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  expression = ast.ExpressionStatement(statement)
  var infix = ast.InfixExpression(expression.expression)
  test.eq_value("+", infix.tok.t_type)
  test.eq_value("+", infix.operator)
  identifier = Identifier(infix.right)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("y", identifier.variable_name)
  identifier = Identifier(infix.left)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  program = test.get_program("""
  fn(){
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  function_literal = ast.FunctionLiteral(expression.expression)

  # fn
  test.eq_value("FUNCTION", function_literal.tok.t_type)

  # ()
  parameters = function_literal.parameters
  test.eq_value(0, parameters[].len)

  # { }
  block_statement = function_literal.body
  test.eq_value(0, block_statement.statements.len)


  program = test.get_program("""
  fn(x){
    x;
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  function_literal = ast.FunctionLiteral(expression.expression)

  # fn
  test.eq_value("FUNCTION", function_literal.tok.t_type)

  # (x)
  parameters = function_literal.parameters
  test.eq_value(1, parameters[].len)
  identifier = parameters[0]
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  # { x; }
  block_statement = function_literal.body
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  expression = ast.ExpressionStatement(statement)
  identifier = Identifier(expression.expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

# outline: whther be able to parse call expression
# expected_value: expected call expression
block call_expression_test:
  var program = test.get_program("add(1, 2 * 3, x + y)")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var call_expression = ast.CallExpression(expression.expression)

  # add
  var function =  ast.Identifier(call_expression.function)
  test.eq_value("IDENT", function.tok.t_type)
  test.eq_value("add", function.variable_name)
  test.eq_value("(", call_expression.tok.t_type)

  # arguments
  var arguments = call_expression.arguments
  test.eq_value(3, arguments[].len)

  # 1
  var arg = arguments[][0]
  test.eq_value("INT", ast.IntegerLiteral(arg).tok.t_type)
  test.eq_value(1, ast.IntegerLiteral(arg).number)

  # 2 * 3
  arg = arguments[][1]
  var infix = ast.InfixExpression(arg)
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  var integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(2, integer_literal.number)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(3, integer_literal.number)

  # x + y
  arg = arguments[][2]
  infix = ast.InfixExpression(arg)
  test.eq_value("+", infix.tok.t_type)
  test.eq_value("+", infix.operator)
  var ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)
  ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)

# outline: whther be able to parse array literal test
# expected_value: expected array literal test
block array_literal_test:
  # [1, 2 * 2, x + y]
  var program = test.get_program("[1, 2 * 2, x + y]")
  test.eq_value(1, program.statements.len)
  var expression = ast.ExpressionStatement(program.statements[0])
  var array_literal = ast.ArrayLiteral(expression.expression)
  eq_value("[", array_literal.tok.t_type)
  var expressions = array_literal.elements
  test.eq_value(3, expressions[].len)

  # 1
  var integer_literal = ast.IntegerLiteral(expressions[][0])
  eq_value("INT", integer_literal.tok.t_type)
  eq_value(1, integer_literal.number)

  # 2 * 2
  var infix = ast.InfixExpression(expressions[][1])
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(2, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(2, integer_literal.number)

  # x + y
  infix = ast.InfixExpression(expressions[][2])
  test.eq_value("+", infix.tok.t_type)
  test.eq_value("+", infix.operator)
  var ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)
  ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)

  # [10 * 2]
  program = test.get_program("[10 * 2]")
  test.eq_value(1, program.statements.len)
  expression = ast.ExpressionStatement(program.statements[0])
  array_literal = ast.ArrayLiteral(expression.expression)
  eq_value("[", array_literal.tok.t_type)
  expressions = array_literal.elements
  test.eq_value(1, expressions[].len)

  # 10 * 2
  infix = ast.InfixExpression(expressions[][0])
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(2, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(10, integer_literal.number)

# outline: whther be able to parse index_expression test
# expected_value: expected index_expression test
block index_expression_test:
  # arr[1]
  var program = test.get_program("arr[1]")
  test.eq_value(1, program.statements.len)
  var expression = ast.ExpressionStatement(program.statements[0])
  var index = ast.IndexExpression(expression.expression)
  test.eq_value("[", index.tok.t_type)

  # arr
  var left = ast.Identifier(index.left)
  test.eq_value("IDENT", left.tok.t_type)
  test.eq_value("arr", left.variable_name)

  # 1
  var integer_literal = ast.IntegerLiteral(index.index)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(1, integer_literal.number)

  # arr[x * y]
  program = test.get_program("arr[x * y]")
  test.eq_value(1, program.statements.len)
  expression = ast.ExpressionStatement(program.statements[0])
  index = ast.IndexExpression(expression.expression)
  test.eq_value("[", index.tok.t_type)

  # arr
  left = ast.Identifier(index.left)
  test.eq_value("IDENT", left.tok.t_type)
  test.eq_value("arr", left.variable_name)

  # x * y
  var infix = ast.InfixExpression(index.index)
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  var identifier = Identifier(infix.right)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("y", identifier.variable_name)
  identifier = Identifier(infix.left)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

# outline: whther be able to parse hash_literal test
# expected_value: expected hash_literal test
block hash_literal_test:
  # arr[1]
  var program = test.get_program("{\"a\": 1}")
  test.eq_value(1, program.statements.len)

  var expression = ast.ExpressionStatement(program.statements[0])
  var hash = ast.HashLiteral(expression.expression)
]#