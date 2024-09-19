class Setting < ActiveRecord::Base

  serialize :value

  class << self
    attr_accessor :__cache
    attr_accessor :__cache_expires_in
  end

  def self.method_missing(method, *args)
    method = method.to_s

    # set mode
    if method[-1,1] == "="

      if args.size > 0
        # key/value setup
        method = method.chop
        method = method.chop if method[-1,1] == "!"
        value = { value: args[0] }
        setting = self.find_by(key: method)
        if value[:value].nil?
          setting.destroy if setting
        else
          setting = self.new if !setting
          setting.key = method.to_s if setting.key.blank?
          setting.value = value
          if setting.save
            return value[:value]
          end
        end
      end

    # get mode
    else

      # skip memcache?
      if method[-1,1] == "!"
        method = method.chop
        skip_cache = true
      end

      skip_cache = true

      if skip_cache.nil? && (result = @__cache.read(method.to_s))
        return result[:value]
      else
        result = self.find_by(key: method)
        if result
          return result.value[:value]
        end
      end

    end
    
    return nil
  end

=begin
  def self.method_missing(method, *args)

    # init memcache if needed
    @__cache = ActiveSupport::Cache::MemCacheStore.new if @__cache.nil?
    @__cache_expires_in = 6.hours if @__cache_expires_in.nil?

    method = method.to_s

    # set mode
    if method[-1,1] == "="

      if args.size > 0
        # key/value setup
        method = method.chop
        method = method.chop if method[-1,1] == "!"
        value = {:value => args[0]}
        @__cache.write(method, value, :expires_in => @__cache_expires_in)
        setting = self.find(:first, :conditions => {:key => method})
        if value[:value].nil?
          setting.destroy if setting
          @__cache.write(method, nil, :expires_in => 0.seconds)
        else
          setting = self.new if !setting
          setting.key = method.to_s if setting.key.blank?
          setting.value = value
          if setting.save
            return value[:value]
          end
        end
      end

    # get mode
    else

      # skip memcache?
      if method[-1,1] == "!"
        method = method.chop
        skip_cache = true
      end

      if skip_cache.nil? && (result = @__cache.read(method.to_s))
        return result[:value]
      else
        result = self.find_by(key: method)
        if result
          @__cache.write(method, result.value, :expires_in => @__cache_expires_in)
          return result.value[:value]
        end
      end

    end
    return nil

  end
=end

end
