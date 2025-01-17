import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/dart/invert_boolean_expression.dart';
import 'src/assists/dart/swap_then_else_expression.dart';
import 'src/assists/flutter/use_edge_insets_zero.dart';
import 'src/assists/flutter/wrap_with_expanded.dart';
import 'src/assists/flutter/wrap_with_layout_builder.dart';
import 'src/assists/flutter/wrap_with_stack.dart';
import 'src/lints/dart/always_declare_parameter_names.dart';
import 'src/lints/dart/avoid_duplicate_import.dart';
import 'src/lints/dart/avoid_dynamic.dart';
import 'src/lints/dart/avoid_empty_blocks.dart';
import 'src/lints/dart/avoid_inverted_boolean_expressions.dart';
import 'src/lints/dart/boolean_prefix.dart';
import 'src/lints/dart/max_lines_for_file.dart';
import 'src/lints/dart/max_lines_for_function.dart';
import 'src/lints/dart/prefer_declaring_const_constructors.dart';
import 'src/lints/dart/prefer_immediate_return.dart';
import 'src/lints/dart/prefer_iterable_first.dart';
import 'src/lints/dart/prefer_iterable_last.dart';
import 'src/lints/dart/prefer_underscore_for_unused_callback_parameters.dart';
import 'src/lints/flutter/avoid_returning_widgets.dart';
import 'src/lints/flutter/avoid_single_child_in_flex.dart';
import 'src/lints/flutter/prefer_async_callback.dart';
import 'src/lints/flutter/prefer_border_from_border_side.dart';
import 'src/lints/flutter/prefer_border_radius_all.dart';
import 'src/lints/flutter/prefer_dedicated_media_query_method.dart';
import 'src/lints/flutter/prefer_spacer.dart';
import 'src/lints/flutter/prefer_text_rich.dart';
import 'src/lints/flutter/prefer_value_changed.dart';
import 'src/lints/flutter/prefer_void_callback.dart';
import 'src/lints/flutter/proper_controller_dispose.dart';
import 'src/lints/flutter/proper_edge_insets_constructor.dart';
import 'src/lints/flutter/proper_expanded_and_flexible.dart';
import 'src/lints/flutter/proper_from_environment.dart';
import 'src/lints/flutter/proper_super_dispose.dart';
import 'src/lints/flutter/proper_super_init_state.dart';

/// This is the entry point of Pyramid Linter.
PluginBase createPlugin() => _PyramidLinter();

class _PyramidLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        // Dart lints
        const AlwaysDeclareParameterNames(),
        const AvoidDuplicateImport(),
        const AvoidDynamic(),
        const AvoidEmptyBlocks(),
        const AvoidInvertedBooleanExpressions(),
        BooleanPrefix.fromConfigs(configs),
        MaxLinesForFile(configs),
        MaxLinesForFunction(configs),
        const PreferDeclaringConstConstructors(),
        const PreferImmediateReturn(),
        const PreferIterableFirst(),
        const PreferIterableLast(),
        const PreferUnderscoreForUnusedCallbackParameters(),
        // Flutter lints
        const AvoidReturningWidgets(),
        const AvoidSingleChildInFlex(),
        const PreferAsyncCallback(),
        const PreferBorderFromBorderSide(),
        const PreferBorderRadiusAll(),
        const PreferDedicatedMediaQueryMethod(),
        const PreferSpacer(),
        const PreferTextRich(),
        const PreferValueChanged(),
        const PreferVoidCallback(),
        const ProperControllerDispose(),
        const ProperEdgeInsetsConstructor(),
        const ProperExpandedAndFlexible(),
        const ProperFromEnvironment(),
        const ProperSuperDispose(),
        const ProperSuperInitState(),
      ];

  @override
  List<Assist> getAssists() => [
        InvertBooleanExpression(),
        SwapThenElseExpression(),
        UseEdgeInsetsZero(),
        WrapWithExpanded(),
        WrapWithLayoutBuilder(),
        WrapWithStack(),
      ];
}
