module DicePoolsHelper
  def parse_die_result(die_results)
    die_results = die_results.to_a.map do |die_result|
      parse_result(*die_result, 'die')
    end.join.html_safe

    die_results.empty? ? blank_result_tag('die') : die_results
  end

  def parse_results(results)
    results = results.map { |result| parse_result(*result) }.join.html_safe

    results.empty? ? '<div class="result blank"></div>'.html_safe : results
  end

  private

  def parse_result(result_type, result_type_count, type = '')
    die_html = "<div class='#{[type, 'result'].reject(&:blank?).join('-')} " \
      "#{result_type}'></div>"
    Array.new(result_type_count, die_html).join.html_safe
  end

  def blank_result_tag(type = '')
    "<div class='#{[type, 'result'].reject(&:blank?).join('-')} " \
      "blank'></div>".html_safe
  end
end
