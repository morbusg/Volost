module TextMangler

  #def bbcode2markdown(txt)
  #  many_re = /(\[quote:(\w+)(?:="([\w _-]+)")?\])/
  #  quotes = txt.scan(many_re).reverse
  #  # => quotes = [['[quote:abcd1234="foo"]', 'abcd1234', 'foo'], [...]] 
  #  for quote in quotes do
  #    quote[0] = Regexp.escape(quote[0])
  #    quote_re = /(#{quote[0]}(.+?)\[\/quote:#{quote[1]}\])/m
  #    txt =~ quote_re
  #    orig_quote_wo_tags = $2
  #    orig_quote_wo_tags.gsub!(
  #      /^/,'>').gsub!(
  #      /$/,"  ").sub!(
  #      /\A/, "> **#{quote[2]}:**\n")
  #    txt.sub!(quote_re, orig_quote_wo_tags)
  #  end
  #  return txt
  #end

  #def bbcode2markdown(txt)
  #  return "" if txt.nil?
  #  @quotedusers = {}
  #  txt.gsub!(/\*/,'')

  #  txt.scan(/#{START}/).each_with_index { |match,index|
  #    txt.gsub!(INSIDEQUOTE) { |str| $2.gsub(/^(.)/, '>\1').gsub(/(.)$/, "\n\\1\n") }
  #    depth = '>' * (index + 1)
  #    if $1
  #      @quotedusers[depth] = $1
  #    end
  #  }

  #  @quotedusers.each { |depth,user|
  #    txt.sub!(/^#{depth}(\w)/, "#{depth}**#{user}**:  \\1")
  #  }
  #end

  # TODO utilize StringScanner. same goes for import-script
  def img_base(img)
    return " <img class=\"smiley\" src=\"/images/smilies/#{img}.gif\" /> "
  end

  def emotize(txt) # {{{
    #txt.gsub(/\w+([bdfghjklmnprstv][aeiouyäö])/, '&shy;\1/&shy;')
    #start = /(\s|<p>)/
    #stop = /(\s|[:punct:]|<\/p>|\))/
    #txt.gsub(
    #  /#{start}[:=]-?\)#{stop}/,              "\\1#{img_base(1)}\\2").gsub(
    #  /#{start}[:=]-?\(#{stop}/,              "\\1#{img_base(2)}\\2").gsub(
    #  /#{start};-?[)D]#{stop}/,               "\\1#{img_base(3)}\\2").gsub(
    #  /#{start}[:=8]-?[Pp]#{stop}/,           "\\1#{img_base(4)}\\2").gsub(
    #  /#{start}[:=]-?D#{stop}/,               "\\1#{img_base(5)}\\2").gsub(
    #  /#{start}[:=]´-?[(|\/\\]#{stop}/,       "\\1#{img_base(6)}\\2").gsub(
    #  /#{start}[:=]-?\*#{stop}/,              "\\1#{img_base(8)}\\2").gsub(
    #  /#{start}[:=]\^?\}#{stop}/,             "\\1#{img_base(9)}\\2").gsub(
    #  /#{start}[O0][:=]-?\)#{stop}/,          "\\1#{img_base(10)}\\2").gsub(
    #  /#{start}[8:=]-?[Xx]#{stop}/,           "\\1#{img_base(11)}\\2").gsub(
    #  /#{start}[:=]-?[\/\\]#{stop}/,          "\\1#{img_base(12)}\\2").gsub(
    #  /#{start}\}?[xX:8=]-?[@(&|]#{stop}/,    "\\1#{img_base(13)}\\2").gsub(
    #  /#{start}[|Xx]-?D#{stop}/,              "\\1#{img_base(14)}\\2").gsub(
    #  /#{start}8-?\|#{stop}/,                 "\\1#{img_base(15)}\\2").gsub(
    #  /#{start}[8:=]-?[oO]#{stop}/,           "\\1#{img_base(16)}\\2").gsub(
    #  /#{start}B-?[)D]#{stop}/,               "\\1#{img_base(17)}\\2").gsub(
    #  /#{start}\[[:=8]-?\)#{stop}/,           "\\1#{img_base(18)}\\2").gsub(
    #  /#{start}[:=]-?[7?S$]#{stop}/,          "\\1#{img_base(19)}\\2").gsub(
    #  /#{start}[%8]-?[Pp]#{stop}/,            "\\1#{img_base(20)}\\2").gsub(
    #  /#{start}\}[:=]-?[)D]#{stop}/,          "\\1#{img_base(23)}\\2").gsub(
    #  /#{start}E\^#{stop}/,                   "\\1#{img_base(26)}\\2").gsub(
    #  /#{start}\|_P#{stop}/,                  "\\1#{img_base(27)}\\2").gsub(
    #  /#{start}3-?[)D]#{stop}/,               "\\1#{img_base(28)}\\2")
  end # }}}

end
