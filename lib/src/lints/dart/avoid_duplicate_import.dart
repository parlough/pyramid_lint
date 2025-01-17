import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/constants.dart';
import '../../utils/iterable_extensions.dart';

class AvoidDuplicateImport extends DartLintRule {
  const AvoidDuplicateImport() : super(code: _code);

  static const name = 'avoid_duplicate_import';

  static const _code = LintCode(
    name: name,
    problemMessage: 'There is a duplicate import.',
    correctionMessage: 'Consider combining or removing the duplicate imports.',
    url: '$docUrl#${AvoidDuplicateImport.name}',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final importDirectives = node.directives.whereType<ImportDirective>();
      final duplicateUrls = importDirectives
          .map((e) => e.uri.stringValue)
          .whereNotNull()
          .duplicates;

      for (final importDirective in importDirectives) {
        final url = importDirective.uri.stringValue;
        if (duplicateUrls.contains(url)) {
          reporter.reportErrorForNode(_code, importDirective.uri);
        }
      }
    });
  }
}
