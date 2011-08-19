require 'rubygems'
require 'toodledo'

load 'slimtask.rb'

# File containing the following (not kept in repository). Format:
# $key_user_id = "USER ID"
# $key_password = "PASSWORD"
#
load "keyconf.rb"

config = {
  "connection" => {
    "url" => "http://www.toodledo.com/api.php",
    "user_id" => $key_user_id,
    "password" => $key_password
  }
}

FOLDERS = ['Projects', 'Household', 'Personal', 'HCI', 'Community']
CONTEXTS = ['Agendas', 'Calls', 'Computer', 'Email', 'Errands', 'Home',
            'Someday', 'WorkOffice', nil]

#log = Logger.new(STDOUT)
#log.level = Logger::DEBUG

Toodledo.set_config(config)

tasks = []
Toodledo.begin do |session|
  for folder in FOLDERS
    for context in CONTEXTS
      tasks = tasks + session.get_tasks({:notcomp => true,
                                         :context => context,
                                         :folder => folder})
      if folder.nil? then folder = "" end
      if context.nil? then context = "" end
      print "Folder - " + folder + "; Context - " + context + "; Task tally - " +
          tasks.length.to_s + "\n"
    end
  end
end
print "Toodledo tasks: " + tasks.length.to_s + "\n"
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
print "Tasks: " + tasks.length.to_s + "\n"

File.open("notcomp-tasks.marshal", "w+") do |f|
  Marshal.dump(ntasks, f);
end

