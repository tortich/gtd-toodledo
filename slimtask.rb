###
# A reduced task description based on a Toodledo task
#

class SlimTask
  attr_reader :title, :note, :context, :folder, :project, :completed, :active, :added,
              :priority, :modified
  def initialize(title, note, context, folder, tag, completed, added, priority, modified)
    @title = title
    @note = note
    @context = context
    @folder = folder
    @project = tag
    @completed = completed
    @added = added
    @priority = priority
    @modified = modified
  end
end