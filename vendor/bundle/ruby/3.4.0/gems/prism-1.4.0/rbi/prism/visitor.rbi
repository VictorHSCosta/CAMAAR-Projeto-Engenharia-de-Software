# typed: strict

=begin
This file is generated by the templates/template.rb script and should not be
modified manually. See templates/rbi/prism/visitor.rbi.erb
if you are looking to modify the template
=end

class Prism::BasicVisitor
  sig { params(node: T.nilable(Prism::Node)).void }
  def visit(node); end

  sig { params(nodes: T::Array[T.nilable(Prism::Node)]).void }
  def visit_all(nodes); end

  sig { params(node: Prism::Node).void }
  def visit_child_nodes(node); end
end

class Prism::Visitor < Prism::BasicVisitor
  sig { params(node: Prism::AliasGlobalVariableNode).void }
  def visit_alias_global_variable_node(node); end

  sig { params(node: Prism::AliasMethodNode).void }
  def visit_alias_method_node(node); end

  sig { params(node: Prism::AlternationPatternNode).void }
  def visit_alternation_pattern_node(node); end

  sig { params(node: Prism::AndNode).void }
  def visit_and_node(node); end

  sig { params(node: Prism::ArgumentsNode).void }
  def visit_arguments_node(node); end

  sig { params(node: Prism::ArrayNode).void }
  def visit_array_node(node); end

  sig { params(node: Prism::ArrayPatternNode).void }
  def visit_array_pattern_node(node); end

  sig { params(node: Prism::AssocNode).void }
  def visit_assoc_node(node); end

  sig { params(node: Prism::AssocSplatNode).void }
  def visit_assoc_splat_node(node); end

  sig { params(node: Prism::BackReferenceReadNode).void }
  def visit_back_reference_read_node(node); end

  sig { params(node: Prism::BeginNode).void }
  def visit_begin_node(node); end

  sig { params(node: Prism::BlockArgumentNode).void }
  def visit_block_argument_node(node); end

  sig { params(node: Prism::BlockLocalVariableNode).void }
  def visit_block_local_variable_node(node); end

  sig { params(node: Prism::BlockNode).void }
  def visit_block_node(node); end

  sig { params(node: Prism::BlockParameterNode).void }
  def visit_block_parameter_node(node); end

  sig { params(node: Prism::BlockParametersNode).void }
  def visit_block_parameters_node(node); end

  sig { params(node: Prism::BreakNode).void }
  def visit_break_node(node); end

  sig { params(node: Prism::CallAndWriteNode).void }
  def visit_call_and_write_node(node); end

  sig { params(node: Prism::CallNode).void }
  def visit_call_node(node); end

  sig { params(node: Prism::CallOperatorWriteNode).void }
  def visit_call_operator_write_node(node); end

  sig { params(node: Prism::CallOrWriteNode).void }
  def visit_call_or_write_node(node); end

  sig { params(node: Prism::CallTargetNode).void }
  def visit_call_target_node(node); end

  sig { params(node: Prism::CapturePatternNode).void }
  def visit_capture_pattern_node(node); end

  sig { params(node: Prism::CaseMatchNode).void }
  def visit_case_match_node(node); end

  sig { params(node: Prism::CaseNode).void }
  def visit_case_node(node); end

  sig { params(node: Prism::ClassNode).void }
  def visit_class_node(node); end

  sig { params(node: Prism::ClassVariableAndWriteNode).void }
  def visit_class_variable_and_write_node(node); end

  sig { params(node: Prism::ClassVariableOperatorWriteNode).void }
  def visit_class_variable_operator_write_node(node); end

  sig { params(node: Prism::ClassVariableOrWriteNode).void }
  def visit_class_variable_or_write_node(node); end

  sig { params(node: Prism::ClassVariableReadNode).void }
  def visit_class_variable_read_node(node); end

  sig { params(node: Prism::ClassVariableTargetNode).void }
  def visit_class_variable_target_node(node); end

  sig { params(node: Prism::ClassVariableWriteNode).void }
  def visit_class_variable_write_node(node); end

  sig { params(node: Prism::ConstantAndWriteNode).void }
  def visit_constant_and_write_node(node); end

  sig { params(node: Prism::ConstantOperatorWriteNode).void }
  def visit_constant_operator_write_node(node); end

  sig { params(node: Prism::ConstantOrWriteNode).void }
  def visit_constant_or_write_node(node); end

  sig { params(node: Prism::ConstantPathAndWriteNode).void }
  def visit_constant_path_and_write_node(node); end

  sig { params(node: Prism::ConstantPathNode).void }
  def visit_constant_path_node(node); end

  sig { params(node: Prism::ConstantPathOperatorWriteNode).void }
  def visit_constant_path_operator_write_node(node); end

  sig { params(node: Prism::ConstantPathOrWriteNode).void }
  def visit_constant_path_or_write_node(node); end

  sig { params(node: Prism::ConstantPathTargetNode).void }
  def visit_constant_path_target_node(node); end

  sig { params(node: Prism::ConstantPathWriteNode).void }
  def visit_constant_path_write_node(node); end

  sig { params(node: Prism::ConstantReadNode).void }
  def visit_constant_read_node(node); end

  sig { params(node: Prism::ConstantTargetNode).void }
  def visit_constant_target_node(node); end

  sig { params(node: Prism::ConstantWriteNode).void }
  def visit_constant_write_node(node); end

  sig { params(node: Prism::DefNode).void }
  def visit_def_node(node); end

  sig { params(node: Prism::DefinedNode).void }
  def visit_defined_node(node); end

  sig { params(node: Prism::ElseNode).void }
  def visit_else_node(node); end

  sig { params(node: Prism::EmbeddedStatementsNode).void }
  def visit_embedded_statements_node(node); end

  sig { params(node: Prism::EmbeddedVariableNode).void }
  def visit_embedded_variable_node(node); end

  sig { params(node: Prism::EnsureNode).void }
  def visit_ensure_node(node); end

  sig { params(node: Prism::FalseNode).void }
  def visit_false_node(node); end

  sig { params(node: Prism::FindPatternNode).void }
  def visit_find_pattern_node(node); end

  sig { params(node: Prism::FlipFlopNode).void }
  def visit_flip_flop_node(node); end

  sig { params(node: Prism::FloatNode).void }
  def visit_float_node(node); end

  sig { params(node: Prism::ForNode).void }
  def visit_for_node(node); end

  sig { params(node: Prism::ForwardingArgumentsNode).void }
  def visit_forwarding_arguments_node(node); end

  sig { params(node: Prism::ForwardingParameterNode).void }
  def visit_forwarding_parameter_node(node); end

  sig { params(node: Prism::ForwardingSuperNode).void }
  def visit_forwarding_super_node(node); end

  sig { params(node: Prism::GlobalVariableAndWriteNode).void }
  def visit_global_variable_and_write_node(node); end

  sig { params(node: Prism::GlobalVariableOperatorWriteNode).void }
  def visit_global_variable_operator_write_node(node); end

  sig { params(node: Prism::GlobalVariableOrWriteNode).void }
  def visit_global_variable_or_write_node(node); end

  sig { params(node: Prism::GlobalVariableReadNode).void }
  def visit_global_variable_read_node(node); end

  sig { params(node: Prism::GlobalVariableTargetNode).void }
  def visit_global_variable_target_node(node); end

  sig { params(node: Prism::GlobalVariableWriteNode).void }
  def visit_global_variable_write_node(node); end

  sig { params(node: Prism::HashNode).void }
  def visit_hash_node(node); end

  sig { params(node: Prism::HashPatternNode).void }
  def visit_hash_pattern_node(node); end

  sig { params(node: Prism::IfNode).void }
  def visit_if_node(node); end

  sig { params(node: Prism::ImaginaryNode).void }
  def visit_imaginary_node(node); end

  sig { params(node: Prism::ImplicitNode).void }
  def visit_implicit_node(node); end

  sig { params(node: Prism::ImplicitRestNode).void }
  def visit_implicit_rest_node(node); end

  sig { params(node: Prism::InNode).void }
  def visit_in_node(node); end

  sig { params(node: Prism::IndexAndWriteNode).void }
  def visit_index_and_write_node(node); end

  sig { params(node: Prism::IndexOperatorWriteNode).void }
  def visit_index_operator_write_node(node); end

  sig { params(node: Prism::IndexOrWriteNode).void }
  def visit_index_or_write_node(node); end

  sig { params(node: Prism::IndexTargetNode).void }
  def visit_index_target_node(node); end

  sig { params(node: Prism::InstanceVariableAndWriteNode).void }
  def visit_instance_variable_and_write_node(node); end

  sig { params(node: Prism::InstanceVariableOperatorWriteNode).void }
  def visit_instance_variable_operator_write_node(node); end

  sig { params(node: Prism::InstanceVariableOrWriteNode).void }
  def visit_instance_variable_or_write_node(node); end

  sig { params(node: Prism::InstanceVariableReadNode).void }
  def visit_instance_variable_read_node(node); end

  sig { params(node: Prism::InstanceVariableTargetNode).void }
  def visit_instance_variable_target_node(node); end

  sig { params(node: Prism::InstanceVariableWriteNode).void }
  def visit_instance_variable_write_node(node); end

  sig { params(node: Prism::IntegerNode).void }
  def visit_integer_node(node); end

  sig { params(node: Prism::InterpolatedMatchLastLineNode).void }
  def visit_interpolated_match_last_line_node(node); end

  sig { params(node: Prism::InterpolatedRegularExpressionNode).void }
  def visit_interpolated_regular_expression_node(node); end

  sig { params(node: Prism::InterpolatedStringNode).void }
  def visit_interpolated_string_node(node); end

  sig { params(node: Prism::InterpolatedSymbolNode).void }
  def visit_interpolated_symbol_node(node); end

  sig { params(node: Prism::InterpolatedXStringNode).void }
  def visit_interpolated_x_string_node(node); end

  sig { params(node: Prism::ItLocalVariableReadNode).void }
  def visit_it_local_variable_read_node(node); end

  sig { params(node: Prism::ItParametersNode).void }
  def visit_it_parameters_node(node); end

  sig { params(node: Prism::KeywordHashNode).void }
  def visit_keyword_hash_node(node); end

  sig { params(node: Prism::KeywordRestParameterNode).void }
  def visit_keyword_rest_parameter_node(node); end

  sig { params(node: Prism::LambdaNode).void }
  def visit_lambda_node(node); end

  sig { params(node: Prism::LocalVariableAndWriteNode).void }
  def visit_local_variable_and_write_node(node); end

  sig { params(node: Prism::LocalVariableOperatorWriteNode).void }
  def visit_local_variable_operator_write_node(node); end

  sig { params(node: Prism::LocalVariableOrWriteNode).void }
  def visit_local_variable_or_write_node(node); end

  sig { params(node: Prism::LocalVariableReadNode).void }
  def visit_local_variable_read_node(node); end

  sig { params(node: Prism::LocalVariableTargetNode).void }
  def visit_local_variable_target_node(node); end

  sig { params(node: Prism::LocalVariableWriteNode).void }
  def visit_local_variable_write_node(node); end

  sig { params(node: Prism::MatchLastLineNode).void }
  def visit_match_last_line_node(node); end

  sig { params(node: Prism::MatchPredicateNode).void }
  def visit_match_predicate_node(node); end

  sig { params(node: Prism::MatchRequiredNode).void }
  def visit_match_required_node(node); end

  sig { params(node: Prism::MatchWriteNode).void }
  def visit_match_write_node(node); end

  sig { params(node: Prism::MissingNode).void }
  def visit_missing_node(node); end

  sig { params(node: Prism::ModuleNode).void }
  def visit_module_node(node); end

  sig { params(node: Prism::MultiTargetNode).void }
  def visit_multi_target_node(node); end

  sig { params(node: Prism::MultiWriteNode).void }
  def visit_multi_write_node(node); end

  sig { params(node: Prism::NextNode).void }
  def visit_next_node(node); end

  sig { params(node: Prism::NilNode).void }
  def visit_nil_node(node); end

  sig { params(node: Prism::NoKeywordsParameterNode).void }
  def visit_no_keywords_parameter_node(node); end

  sig { params(node: Prism::NumberedParametersNode).void }
  def visit_numbered_parameters_node(node); end

  sig { params(node: Prism::NumberedReferenceReadNode).void }
  def visit_numbered_reference_read_node(node); end

  sig { params(node: Prism::OptionalKeywordParameterNode).void }
  def visit_optional_keyword_parameter_node(node); end

  sig { params(node: Prism::OptionalParameterNode).void }
  def visit_optional_parameter_node(node); end

  sig { params(node: Prism::OrNode).void }
  def visit_or_node(node); end

  sig { params(node: Prism::ParametersNode).void }
  def visit_parameters_node(node); end

  sig { params(node: Prism::ParenthesesNode).void }
  def visit_parentheses_node(node); end

  sig { params(node: Prism::PinnedExpressionNode).void }
  def visit_pinned_expression_node(node); end

  sig { params(node: Prism::PinnedVariableNode).void }
  def visit_pinned_variable_node(node); end

  sig { params(node: Prism::PostExecutionNode).void }
  def visit_post_execution_node(node); end

  sig { params(node: Prism::PreExecutionNode).void }
  def visit_pre_execution_node(node); end

  sig { params(node: Prism::ProgramNode).void }
  def visit_program_node(node); end

  sig { params(node: Prism::RangeNode).void }
  def visit_range_node(node); end

  sig { params(node: Prism::RationalNode).void }
  def visit_rational_node(node); end

  sig { params(node: Prism::RedoNode).void }
  def visit_redo_node(node); end

  sig { params(node: Prism::RegularExpressionNode).void }
  def visit_regular_expression_node(node); end

  sig { params(node: Prism::RequiredKeywordParameterNode).void }
  def visit_required_keyword_parameter_node(node); end

  sig { params(node: Prism::RequiredParameterNode).void }
  def visit_required_parameter_node(node); end

  sig { params(node: Prism::RescueModifierNode).void }
  def visit_rescue_modifier_node(node); end

  sig { params(node: Prism::RescueNode).void }
  def visit_rescue_node(node); end

  sig { params(node: Prism::RestParameterNode).void }
  def visit_rest_parameter_node(node); end

  sig { params(node: Prism::RetryNode).void }
  def visit_retry_node(node); end

  sig { params(node: Prism::ReturnNode).void }
  def visit_return_node(node); end

  sig { params(node: Prism::SelfNode).void }
  def visit_self_node(node); end

  sig { params(node: Prism::ShareableConstantNode).void }
  def visit_shareable_constant_node(node); end

  sig { params(node: Prism::SingletonClassNode).void }
  def visit_singleton_class_node(node); end

  sig { params(node: Prism::SourceEncodingNode).void }
  def visit_source_encoding_node(node); end

  sig { params(node: Prism::SourceFileNode).void }
  def visit_source_file_node(node); end

  sig { params(node: Prism::SourceLineNode).void }
  def visit_source_line_node(node); end

  sig { params(node: Prism::SplatNode).void }
  def visit_splat_node(node); end

  sig { params(node: Prism::StatementsNode).void }
  def visit_statements_node(node); end

  sig { params(node: Prism::StringNode).void }
  def visit_string_node(node); end

  sig { params(node: Prism::SuperNode).void }
  def visit_super_node(node); end

  sig { params(node: Prism::SymbolNode).void }
  def visit_symbol_node(node); end

  sig { params(node: Prism::TrueNode).void }
  def visit_true_node(node); end

  sig { params(node: Prism::UndefNode).void }
  def visit_undef_node(node); end

  sig { params(node: Prism::UnlessNode).void }
  def visit_unless_node(node); end

  sig { params(node: Prism::UntilNode).void }
  def visit_until_node(node); end

  sig { params(node: Prism::WhenNode).void }
  def visit_when_node(node); end

  sig { params(node: Prism::WhileNode).void }
  def visit_while_node(node); end

  sig { params(node: Prism::XStringNode).void }
  def visit_x_string_node(node); end

  sig { params(node: Prism::YieldNode).void }
  def visit_yield_node(node); end
end
