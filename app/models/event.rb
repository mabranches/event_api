include ActionController::Helpers
class Event < ActiveRecord::Base
  #TODO maybe optionally keep a published copy of a edited event
  validates :start, presence: true, :if => :published?
  validates :end, presence: true, :if => :published?
  validates :number_of_days, presence: true, :if => :published?
  validates :number_of_days, numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil:true}
  validates :name, presence: true, :if => :published?
  validates :description, presence: true, :if => :published?
  validates :location, presence: true, :if => :published?
  validate :start_grater_end
  validate :date_consistency

  before_validation :fill_date
  alias_method :serializable_hash_old, :serializable_hash

  #show created_at and updated_at as iso8601 standard
  #show description html formatted, maybe it would be best handled on client
  def serializable_hash(obj)
    hash = serializable_hash_old(obj)
    hash.delete("deleted")
    hash["created_at"] = hash["created_at"].iso8601 if hash["created_at"]
    hash["updated_at"] = hash["updated_at"].iso8601 if hash["updated_at"]
    hash["description"] = ApplicationController.helpers.simple_format(hash["description"]) if hash["description"]
    hash
  end

  def destroy
    self.deleted = true
    save(validate:false)
  end

  private
  def start_grater_end
    return unless self.start && self.end
    if(self.start > self.end)
      #TODO add localization
      return errors.add(:start,"start should be less than end")
    end
  end

  def fill_date
    attrs = [self.start, self.end, self.number_of_days]
    #it is not possible to calculate if less than 2 and
    #not necessary with 3
    return if attrs.compact.length != 2
    self.start ||= self.end - self.number_of_days
    self.end ||= self.start + self.number_of_days
    self.number_of_days ||= (self.end - self.start).to_i
  end

  def date_consistency
    return unless self.start && self.end && self.number_of_days
    if (self.number_of_days != (self.end- self.start).to_i)
      #TODO add localization
      return errors.add(:number_of_days, "dates are not consistent with number_of_days")
    end
  end
end
