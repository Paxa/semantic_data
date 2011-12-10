# coding: utf-8
class ActiveRecord::Base
  def self.by_link(param)
    if param =~ /^\d+$/
      find(param)
    else
      record = where(:link => param).first
      raise ActiveRecord::RecordNotFound, "#{self.to_s} not fount" unless record
      record
    end
  end
end