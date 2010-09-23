module ErrorsHelper
  def random_cite
    Cite.find(:all).rand
  end
  
  def missing_message (missing = nil, message = nil)
    missing = missing || ''
    message = message || 'Ooops, strona %s nie znaleziona!'
    
    unless missing.empty?
      missing = awesome_truncate(missing, 20, '...')
      missing.gsub!(/^\/|\/$/, '')
      missing.gsub!('/', ' / ')
      missing = content_tag('q', h(missing.titleize))
    end
    message.gsub! '%s', missing
  end
  
  def debug_request
    dbg = ''
    dbg << (debug @exception) if @exception
    dbg << (debug request)
    dbg << (debug params)
  end
end