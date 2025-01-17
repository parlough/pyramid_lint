import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/class_members_extensions.dart';
import '../../utils/constants.dart';
import '../../utils/type_checker.dart';

class ProperSuperInitState extends DartLintRule {
  const ProperSuperInitState() : super(code: _code);

  static const name = 'proper_super_init_state';

  static const _code = LintCode(
    name: name,
    problemMessage:
        'super.initState() should be called at the start of the initState method.',
    correctionMessage:
        'Try placing super.initState() at the start of the initState method.',
    url: '$docUrl#${ProperSuperInitState.name}',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final extendsClause = node.extendsClause;
      if (extendsClause == null) return;

      final type = extendsClause.superclass.type;
      if (type == null || !widgetStateChecker.isAssignableFromType(type)) {
        return;
      }

      final body = node.members.findMethodDeclarationByName('initState')?.body;
      if (body == null || body is! BlockFunctionBody) return;

      final statements = body.block.statements;
      if (statements.isEmpty) return;

      if (statements.first.toSource() == 'super.initState();') return;

      final superInitStateStatement = statements.firstWhereOrNull(
        (statement) => statement.toSource() == 'super.initState();',
      );
      if (superInitStateStatement == null) return;

      reporter.reportErrorForNode(code, superInitStateStatement);
    });
  }

  @override
  List<Fix> getFixes() => [_PlaceSuperInitStateAtTheStart()];
}

class _PlaceSuperInitStateAtTheStart extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addClassDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final body = node.members.findMethodDeclarationByName('initState')?.body;
      if (body == null || body is! BlockFunctionBody) return;

      final statements = body.block.statements;
      if (statements.isEmpty) return;

      final superInitStateStatement = statements.firstWhereOrNull(
        (statement) => statement.toSource() == 'super.initState();',
      );
      if (superInitStateStatement == null) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Put super.initState() at the start of the initState method',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        final superInitStateStatementIndex = statements.indexOf(
          superInitStateStatement,
        );
        final firstStatement = statements.first;

        for (var i = superInitStateStatementIndex; i > 0; i--) {
          builder.addSimpleReplacement(
            statements[i].sourceRange,
            statements[i - 1].toSource(),
          );
        }

        builder.addSimpleReplacement(
          firstStatement.sourceRange,
          superInitStateStatement.toSource(),
        );
      });
    });
  }
}
