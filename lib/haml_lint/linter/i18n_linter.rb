# frozen_string_literal: true

module HamlLint
  class Linter::I18n < Linter
    include LinterRegistry

    MESSAGE = 'Text needs translation'

    def visit_tag(node)
      record_lint(node, MESSAGE) unless node.text.blank?
    end
  end
end
