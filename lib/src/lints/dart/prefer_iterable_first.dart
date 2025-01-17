import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/constants.dart';
import '../../utils/type_checker.dart';

class PreferIterableFirst extends DartLintRule {
  const PreferIterableFirst() : super(code: _code);

  static const name = 'prefer_iterable_first';

  static const _code = LintCode(
    name: name,
    problemMessage: '{0} is more verbose than iterable.first.',
    correctionMessage: 'Try replacing {1} with {2}.',
    url: '$docUrl#${PreferIterableFirst.name}',
    errorSeverity: ErrorSeverity.INFO,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIndexExpression((node) {
      final targetType = node.realTarget.staticType;
      if (targetType == null || !listChecker.isAssignableFromType(targetType)) {
        return;
      }

      final indexExpression = node.index;
      if (indexExpression is! IntegerLiteral || indexExpression.value != 0) {
        return;
      }

      reporter.reportErrorForNode(
        code,
        node,
        [
          'list[0]',
          node.toSource(),
          '${node.realTarget.toSource()}.first',
        ],
      );
    });

    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'elementAt') return;

      if (node.argumentList.arguments.length != 1) return;

      final argument = node.argumentList.arguments.first;
      if (argument is! IntegerLiteral || argument.value != 0) return;

      reporter.reportErrorForNode(
        code,
        node,
        [
          'list.elementAt(0)',
          node.toSource(),
          '${node.realTarget?.toSource()}.first',
        ],
      );
    });
  }

  @override
  List<Fix> getFixes() => [_ReplaceWithIterableFirst()];
}

class _ReplaceWithIterableFirst extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addIndexExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with iterable.first',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        final replacement = node.isCascaded ? 'first' : '.first';
        builder.addSimpleReplacement(
          range.startEnd(node.leftBracket, node.rightBracket),
          replacement,
        );
      });
    });

    context.registry.addMethodInvocation((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with iterable.first',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          range.startEnd(node.methodName, node.argumentList),
          'first',
        );
      });
    });
  }
}
