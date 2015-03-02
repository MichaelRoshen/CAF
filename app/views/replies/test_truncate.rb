counters = ActiveSupport::HashWithIndifferentAccess.new
counters[:foo] = 1

counters.fetch('foo')          # => 1
counters.fetch(:bar, 0)        # => 0
counters.fetch(:bar) { |key| 0 } # => 0
counters.fetch(:zoo)           # => KeyError: key not found: "zoo"


stream = capture(:stdout) { puts 'notice' }
stream # => "notice\n"

stream = capture(:stderr) { warn 'error' }
stream # => "error\n"

 
capture(*args) Link

The capture method allows you to extract part of a template into a variable. You can then use this variable anywhere in your templates or layout.

The capture method can be used in ERB templates…

<% @greeting = capture do %>
  Welcome to my shiny new web page!  The date and time is
  <%= Time.now %>
<% end %>

…and Builder (RXML) templates.

@timestamp = capture do
  "The current timestamp is #{Time.now}."
end

You can then use that variable anywhere else. For example:

<html>
<head><title><%= @greeting %></title></head>
<body>
<b><%= @greeting %></b>
</body></html>

 

truncate("Once upon a time in a world far far away", length: 17, separator: ' ')
# => "Once upon a..."

 

runcate("Once upon a time in a world far far away") { link_to "Continue", "#" }
# => "Once upon a time in a wo...<a href="#">Continue</a>"

 

truncate("<p>Once upon a time in a world far far away</p>", escape: false)
# => "<p>Once upon a time in a wo..."

# File actionview/lib/action_view/helpers/text_helper.rb, line 92
def truncate(text, options = {}, &block)
  if text
    length  = options.fetch(:length, 30)

    content = text.truncate(length, options)
    content = options[:escape] == false ? content.html_safe : ERB::Util.html_escape(content)
    content << capture(&block) if block_given? && text.length > length
    content
  end
end

 

def truncate_u(text, length = 30, truncate_string = "...")
    return "" unless text
    return text if text.length < length
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end