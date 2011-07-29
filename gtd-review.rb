require 'rubygems'
require 'toodledo'
#require 'logger'

config = {
  "connection" => {
    "url" => "http://www.toodledo.com/api.php",
    "user_id" => "6d3fc97a36399642",
    "password" => "pr3t5n00dtd"
  }
}

#log = Logger.new(STDOUT)
#log.level = Logger::DEBUG

class SlimTask
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

Toodledo.set_config(config)

tasks = nil
Toodledo.begin do |session|
  tasks = session.get_tasks({:notcomp => true})
end
ntasks = []
tasks.each { |task| 
  ntasks << SlimTask.new(task.title,
                         task.note,
                         task.context.name,
                         task.folder.name,
                         task.tag,
                         task.completed,
                         task.added,
                         task.priority,
                         task.modified) 
}
File.open("notcomp-tasks.marshal", "w+") do |f|
  Marshal.dump(tasks);
end

