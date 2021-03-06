PuppetLint.new_check(:resource_reference_without_title_capital) do
  def check
    resource_indexes.each do |resource|
      resource[:param_tokens].select { |param_token|
        ['require', 'subscribe', 'notify', 'before', 'consume', 'export'].include? param_token.value
      }.each do |param_token|
        value_token = param_token.next_code_token
        check = value_token.next_token
        until check.nil?
          case value_token.next_token.type
          when :CLASSREF
            begin
              if value_token.next_token.next_token.type == :LBRACK
                check_token = value_token.next_token.next_token.next_token
                if check_token.type == :CLASSREF or check_token.type == :NAME
                  notify :error, {
                    :message => 'resource reference with title with capital letter',
                    :line    => check_token.line,
                    :column  => check_token.column
                  }
                end
              end
              value_token = value_token.next_token
              check = value_token.next_token
            end
          else
            value_token = value_token.next_token
            check = value_token.next_token
          end
        end
      end
    end
  end
end

