class Toy < ActiveRecord::Base
  belongs_to :sketch
  belongs_to :user
  has_many :sketch_histories

  # Our toy is running a new sketch. Set current sketch_id to it, check
  # its sketch history to see if its the most recent record and add it if not.
  def update_sketch(sketch)
    self.sketch_id = sketch.id
    history = SketchHistory.where(sketch_id: sketch_id, toy_id: id)
    if history.empty? || history != sketch_histories.last
      SketchHistory.new(sketch_id: sketch_id, toy_id: id).save!
    end
    self.save!
  end
end
