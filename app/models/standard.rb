# == Schema Information
#
# Table name: standards
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  autocomplete :string
#

class Standard < ApplicationRecord
  has_many :lessons_standards
  has_many :lessons, through: :lessons_standards

  validates_uniqueness_of :name, :scope => :autocomplete

  def self.seed
    self.seed_values.map{|x|
      begin
        new(name: x[:name], autocomplete: x[:autocomplete]).save!
      rescue ActiveRecord::RecordInvalid => e
        next
      end
    }
  end

  def self.name_array
    Standard.all.to_a.map{|x| x.name}.uniq
  end

  def to_s
    name
  end

  private
  def self.seed_values # TODO -- FINISH ADDING THIS!
    [
        {name: "NGSS",autocomplete: nil},
        {name: "Common Core ELA",autocomplete: nil},
        {name: "Common Core Math",autocomplete: nil},
        {name: "FAB I Can Statements",autocomplete: nil},
        {name: "21st Century Skills",autocomplete: nil},
        {name: "Other",autocomplete: nil},

        # I CAN BELOW

        {name: "I Can - Safety",autocomplete: "Novice - I can safely conduct myself in a Fab Lab, observe operations and follow general safety protocols under guidance from an instructor."},
        {name: "I Can - Safety",autocomplete: "Intermediate - I can operate equipment in a Fab Lab following safety protocols."},
        {name: "I Can - Safety",autocomplete: "Advanced - I can supervise others in a Fab Lab and ensure safety protocols are being followed."},


        {name: "I Can - Design Process",autocomplete: "Novice - I can modify an existing design under instructor guidance."},
        {name: "I Can - Design Process",autocomplete: "Novice - I can design something in a Fab Lab using a specific process under close instructor guidance."},
        {name: "I Can - Design Process",autocomplete: "Novice - I can create analog models (e.g. sketches, small physical models, etc.) to facilitate a design process."},
        {name: "I Can - Design Process",autocomplete: "Novice - I can record and share my ideas during a design process to document the learning process (e.g. journal writing, group reviews, etc.)"},
        {name: "I Can - Design Process",autocomplete: "Intermediate - I can work with a group to follow multiple common design process steps (e.g. defining the user, brainstorming, prototyping, iterating, etc.)."},
        {name: "I Can - Design Process",autocomplete: "Advanced - I can use a specified process multiple times to design, iterate and fabricate an item with limited instructor intervention."},
        {name: "I Can - Design Process",autocomplete: "Advanced - I can guide others through a design process in a Fab Lab."},


        {name: "I Can - Computer Assisted Design",autocomplete: "Novice - I can draw a basic design using 2D Vector graphics."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Novice - I can draw a basic design using 2D Raster Graphics."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Intermediate - I can draw a basic design using any 3D CAD software."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Intermediate - I can design a part to be fabricated in 2D with dimensional precision and with fabrication tolerances. "},
        {name: "I Can - Computer Assisted Design",autocomplete: "Advanced - I can design a 2D press-fit part."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Advanced - I can design a 3D component using 2D design software (e.g. press-fit or folded components)."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Advanced - I can design a part to be fabricated in 3D with dimensional precision and with fabrication tolerances within 3D software."},
        {name: "I Can - Computer Assisted Design",autocomplete: "Advanced - I can use CAD software to produce multiple drawings of the same part from various projections to depict all of its features."},


        {name: "I Can - Machine Operation",autocomplete: "Novice - I can safely observe a digital fabrication machine working and describe their operation."},
        {name: "I Can - Machine Operation",autocomplete: "Intermediate - I can safely operate a digital fabrication machine under close observation of an instructor."},
        {name: "I Can - Machine Operation",autocomplete: "Advanced - I can safely operate a digital fabrication machine independently or in small groups."},
        {name: "I Can - Machine Operation",autocomplete: "Advanced - I can train others to safely operate a digital fabrication machine."},


        {name: "I Can - Fabrication",autocomplete: "Novice - I can assemble an object using prefabricated components."},
        {name: "I Can - Fabrication",autocomplete: "Novice - I can fabricate pre-designed components using one digital fabrication process under instructor guidance."},
        {name: "I Can - Fabrication",autocomplete: "Intermediate - I can modify pre-designed components and subsequently fabricate the components using one digital fabrication process."},
        {name: "I Can - Fabrication",autocomplete: "Intermediate - I can fabricate components of my own design using a single digital fabrication process."},
        {name: "I Can - Fabrication",autocomplete: "Advanced - I can fabricate objects of my own design using components from multiple digital fabrication processes."}

    ]

  end

end
