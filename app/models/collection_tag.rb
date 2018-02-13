# == Schema Information
#
# Table name: collection_tags
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string           not null
#

class CollectionTag < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

  def self.seed
    [
        {name: "fab certified/tested", desc:"adapted and tested lessons by Fab Foundation team, based on submissions from Fabbers, educators, and makers from the Fab Network and partnering organizations"},
        {name: "big ideas", desc:"open ended projects and activities, using digital fabrication tools to guide learners to design their own inventions or solve community challenges "},
        {name: "games", desc:"lessons featuring build or programming projects around board or video games "},
        {name: "environmental", desc:"lessons focusing on exploring environmental science or solving an ecological challenges "},
        {name: "world culture", desc:"lessons highlighting global awareness, cultural practices, learning about history, holidays, legends, etc."},
        {name: "chevron stem award", desc:"lessons from the Fab Foundation and Chevron STEM Award winners.  Over the past two years, award prizes ranging from $1,000-$5,000 have been give to educators dedicated to innovative lessons and projects for K-12 students, while living up to the Fab Lab mission"}
    ].map{ |i|
      new(name: i[:name], description: i[:desc]).save
    }


  end

  def to_s
    name
  end
  def to_s_cap
    to_s.titleize
  end

end
