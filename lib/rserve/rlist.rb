module Rserve
  class Rlist
    include Enumerable
    attr_reader :names
    attr_reader :data
    def initialize(data=nil,n=nil)
       @names=nil
       @data=[]
       if data
         @data=case data
                    when Array
                    data
                    when Numeric
                    Array.new(data)
                    else
                    raise ArgumentError
                end
        end
        if n
        @names=Array.new(@data.size)
         n.each_index {|i| @names[i]=n[i]} if n.respond_to? :each_index
        end
      end
    def named?
      !@names.nil?
    end
    def [](v)
      if v.is_a? String
        return nil if @names.nil?
        i=@names.index(v)
        return i.nil? ? nil : @data[i]
      elsif v.is_a? Integer
        return @data[i]
      else
        raise ArgumentError,"Should be String or Integer"
      end
    end
    
    def at(v)
      @data[v]
    end
    
    def key_at(v)
      return nil if @names.nil?
      @names[v]
    end
    def size
      @data.size
    end
    
    def each
      @data.each do |v|
        yield v
      end
    end
    
    def set_key_at(i,value)
      if @names.nil?
        @names=Array.new
      end
      if @names.size<size
        (size-@names.size).times {@names.push(nil)}
      end
      
      @names[i]=value if i < size
      
    end
    
    def keys
      @names
    end
    
    def put(key,value)
      if key.nil?
        add(value)
        return nil
      end
      if !names.nil?
        p=names.index(key)
        if !p.nil?
          return @names[p]=value
        end
      end
      i=size
      add(value)
      if(@names.nil?)
        @names=Array.new(i+1)
        while(@names.size<i) do
          @names.push(nil)
        end
        @names.push(key)
      end
      
    end
    def add(a,b=nil)
     if b.nil?
       @data.push(a)
       @names=Array.new(@data.size-1) if @names.nil?
       @names.push(nil)
      else
        @data.insert(a,b)
        @names.insert(a,nil)
      end
    end
    def clear
      @data.clear
      @names=nil
    end
    def clone
      RList.new(@data,@names)
    end
    def remove(elem)
      if elem.is_a? String
        i=@data.index(elem)
      elsif elem.is_a? Integer
        i=elem
      end
      return false if i.nil?
      @data.delete_at(i)
      @names.delete_at(i) unless @names.nil?
      @names=nil if size==0
    end
  end
end